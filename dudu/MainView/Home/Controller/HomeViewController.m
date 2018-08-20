//
//  HomeViewController.m
//  dudu
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HomeViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "CategoryViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
//首页banner列表
-(void)adlist{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:@"17621987169" forKey:@"mobile"];
    [paraDic setObject:@"761614" forKey:@"messageCode"];
    
//    [NetWorkManager requestWithMethod:POST Url:Login Parameters:paraDic success:^(id responseObject) {
//
//    } requestRrror:^(id requestRrror) {
//
//    }];
    
    NSMutableDictionary *para = @{}.mutableCopy;
    [NetWorkManager requestWithMethod:POST Url:AdList Parameters:para success:^(id responseObject) {
        
    } requestRrror:^(id requestRrror) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
//    [self request];
    [self adlist];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpTocategoryController) name:@"pushcategory" object:nil];
    // Do any additional setup after loading the view.
}
- (void)jumpTocategoryController{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CategoryViewController * category = [sb instantiateViewControllerWithIdentifier:@"CategoryViewController"];
    [self.navigationController pushViewController:category animated:YES];
}
-(void)request{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain", nil];
    
    NSMutableDictionary * Para = [[NSMutableDictionary alloc]init];
    [Para setObject:APPKEY forKey:@"app_key"];
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:@"17621987169" forKey:@"strParam"];
    [Para setObject:[paraDic mj_JSONString] forKey:@"data"];
    [Para setObject:@"1.0" forKey:@"version"];
    [Para setObject:[self getTimeNow] forKey:@"timestamp"];
    //获取UUID
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    NSString *strUrl = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [Para setObject:strUrl forKey:@"nonce"];
    [Para setObject:Sendcode forKey:@"name"];
    [Para setObject:@"json" forKey:@"format"];
    NSString * sign = [self paixu:Para];
    [Para setObject:sign forKey:@"sign"];
    NSLog(@"%@",Para);
    
    [manager POST:@"http://47.100.224.21/api/gateway.jhtml" parameters:Para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject)
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
-(NSString *)paixu:(NSDictionary *)dic{
    NSMutableDictionary * newdic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    NSArray *keyArray = [newdic allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortString in sortArray) {
        [valueArray addObject:[dic objectForKey:sortString]];
    }
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < sortArray.count; i++) {
        NSString * str = [NSString stringWithFormat:@"%@",valueArray[i]];
        if (str.length == 0) {
            continue;
        }
        if ([valueArray[i] isKindOfClass:[NSNull class]]) {
            continue;
        }
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@",sortArray[i],valueArray[i]];
        [signArray addObject:keyValueStr];
    }
    NSString *sign1 = [signArray componentsJoinedByString:@"&"];
    NSString * sign2 = [sign1 stringByAppendingString:SIGNKEY];
    
    const char* input = [sign2 UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    return digest;
}

- (NSString *)getTimeNow
{
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
    
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    
    NSString *curTime = [NSString stringWithFormat:@"%llu",theTime];
    return curTime;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
