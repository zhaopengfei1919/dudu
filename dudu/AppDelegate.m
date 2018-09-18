//
//  AppDelegate.m
//  dudu
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTableBarControllerView.h"
#import "WXApi.h"


@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    self.window.rootViewController = [[BaseTableBarControllerView alloc]init];
//    [self.window makeKeyWindow];
    [WXApi startLogByLevel:WXLogLevelNormal logBlock:^(NSString *log) {
        NSLog(@"log : %@", log);
    }];
    
    //向微信注册,发起支付必须注册
    [WXApi registerApp:@"wx50dd81792e10ae50" enableMTA:YES];
//    [WXApi registerApp:@"wx50dd81792e10ae50"];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                break;
            default:
                NSLog(@"支付失败");
                break;
        }
    }
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    NSLog(@"er:%@",url.host);
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString * str = [resultDic safeObjectForKey:@"resultStatus"];
            if ([str intValue] == 9000) {
                NSNotification *notification = [NSNotification notificationWithName:@"PAY_SUCCESS" object:@"success"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PAY_FAILE" object:@"fail"];
            }
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"pay"]) {
        NSString * str = [NSString stringWithFormat:@"%@",url];
        NSRange range = [str rangeOfString:@"ret="];
        NSString * ret = @"";
        if (range.length > 0) {
            ret = [str substringFromIndex:(range.location + range.length + 1)];
        }
        if ([ret intValue] == 0) {
            NSNotification *notification = [NSNotification notificationWithName:@"PAY_SUCCESS" object:@"success"];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PAY_FAILE" object:@"fail"];
        }
    }
    return [WXApi handleOpenURL:url delegate:self];
    return YES;
}
@end
