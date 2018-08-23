//
//  NetWorkManager.m
//  Network
//
//  Created by 枫 on 2017/5/17.
//  Copyright © 2017年 LW. All rights reserved.
//

#import "NetWorkManager.h"
#import <CommonCrypto/CommonDigest.h>

@interface NetWorkManager ()
@end

@implementation NetWorkManager
#pragma mark --  使用单例、GCD一次创建
+(NetWorkManager *)sharedManager
{
    static NetWorkManager *manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [NetWorkManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
        
    });
    return manager;
}

+(void)requestWithMethod:(HTTPMethod)method Url:(NSString *)url Parameters:(id)parameters success:(successBlock)success requestRrror:(errorBlock)requestRrror{
        
    NSString *baseURL = @"";
    baseURL = HTTPURL;
    
    NSMutableDictionary * Para = [[NSMutableDictionary alloc]init];
    [Para setObject:APPKEY forKey:@"app_key"];
    [Para setObject:[parameters mj_JSONString] forKey:@"data"];
    [Para setObject:@"1.0" forKey:@"version"];
    [Para setObject:[[NetWorkManager sharedManager] getTimeNow] forKey:@"timestamp"];
    //获取UUID
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    NSString *strUrl = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [Para setObject:strUrl forKey:@"nonce"];
    [Para setObject:url forKey:@"name"];
    [Para setObject:@"json" forKey:@"format"];
    NSString * sign = [[NetWorkManager sharedManager] paixu:Para];
    [Para setObject:sign forKey:@"sign"];
//    NSLog(@"%@",Para);
    
    switch (method) {
        case POST:{
            [[NetWorkManager sharedManager] POST:baseURL parameters:Para progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//                NSLog(@"success --%@",dic);
                NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//                NSLog(@"success --%@",str);
                if (success) {
                    success(dic);
                }

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
                  if ((error.code <= 0 && response.statusCode == 0 )||response.statusCode == 502) {
                    [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后重试"];
                }else{
                    NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                    if (data == nil) {
                        return ;
                    }
                    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    if ([[responseObject objectForKey:@"msg"] isEqualToString:@"Unauthorized"]) {
                        [[NetWorkManager sharedManager] tokenExpired];
                    }else {
                        [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"msg"]];
                    }
                    NSLog(@"error--%@",responseObject);
                    if (requestRrror) {
                        requestRrror(responseObject);
                    }
                }
            }];
        }
            break;
        default:
            break;
    }
}
-(NSString *)paixu:(NSDictionary *)dic{
    NSMutableDictionary * newdic = [[NSMutableDictionary alloc] initWithDictionary:dic];
//    NSString * data = [newdic safeObjectForKey:@"data"];
//    if ([data isEqualToString:@"{}"]) {
//        [newdic removeObjectForKey:@"data"];
//    }
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

/**token 过期*/
-(void)tokenExpired
{
//UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
//    rootViewController.navigationController pushViewController:(nonnull UIViewController *) animated:(BOOL)

}
@end
