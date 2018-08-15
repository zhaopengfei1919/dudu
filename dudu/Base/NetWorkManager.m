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
        manager.requestSerializer=[AFHTTPRequestSerializer serializer];
        [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", nil]]; 
    });
    return manager;
}

+(void)requestWithMethod:(HTTPMethod)method Url:(NSString *)url Parameters:(id)parameters success:(successBlock)success requestRrror:(errorBlock)requestRrror{
//    if ([FYUser userInfo].token.length > 0) {
//        [[NetWorkManager sharedManager].requestSerializer setValue:[@"token " stringByAppendingString:[FYUser userInfo].token] forHTTPHeaderField:@"Authorization"];
//    }
    
//    [[NetWorkManager sharedManager].requestSerializer setValue:@"application/x-www.form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // 根据当前版本是否上线判断使用正式服接口还是测试服接口
    NSString *baseURL = @"";
    baseURL = HTTPURL;
    NSLog(@"%@%@",baseURL,url);
            
    switch (method) {
        case GET:{
            
            [[NetWorkManager sharedManager] GET:[baseURL stringByAppendingString:url] parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"success --%@",responseObject);
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                 [MBProgressHUD hideActivityIndicator];
                NSLog(@"error-%@",error);
                NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
                
                if ((error.code <= 0 && response.statusCode == 0 )||response.statusCode == 502) {
                    //-1009 没网
                    [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后重试"];
                }else{
                    NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                    if (data == nil) {
                        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后重试"];
                    } else {
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
                }
               
            }];
        }
            break;
        case POST:{
            [[NetWorkManager sharedManager] POST:[baseURL stringByAppendingString:url] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//                NSLog(@"success --%@",dic);
//                [MBProgressHUD hideActivityIndicator];
                // code == 200,请求成功
                NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                if (success) {
                    success(dic);
                }
                NSDictionary * result = [dic safeObjectForKey:@"result"];
                NSString * succeeded = [dic objectForKey:@"succeeded"];
                if ([succeeded intValue] == 1) {
//                    if ([result count] == 0) {
//                        return;
//                    }
                    NSString * sign = [[NetWorkManager sharedManager] shengxu:str];
                    NSLog(@"%@  %@  %@",url,sign,[result safeObjectForKey:@"sign"]);
                    if (![sign isEqualToString:[result safeObjectForKey:@"sign"]]) {
                        [SVProgressHUD showErrorWithStatus:@"SIGN"];
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                 [MBProgressHUD hideActivityIndicator];
                NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
                  if ((error.code <= 0 && response.statusCode == 0 )||response.statusCode == 502) {
                    //-1009 没网
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
-(NSString *)shengxu:(NSString *)dicstr{
    NSData *jsonData = [dicstr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    NSMutableDictionary * newdic = [dic safeObjectForKey:@"result"];
    [newdic removeObjectForKey:@"sign"];
    NSArray *keyArray = [newdic allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortString in sortArray) {
        [valueArray addObject:[newdic objectForKey:sortString]];
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
        if ([valueArray[i] isKindOfClass:[NSArray class]]) {
            NSArray *array = [dicstr componentsSeparatedByString:@"[{"];
            NSArray *array1 = [array[1] componentsSeparatedByString:@"}]"];
            NSString *keyValueStr = [NSString stringWithFormat:@"%@[{%@}]",sortArray[i],array1[0]];
            [signArray addObject:keyValueStr];
        }else{
            NSString *keyValueStr = [NSString stringWithFormat:@"%@%@",sortArray[i],valueArray[i]];
            [signArray addObject:keyValueStr];
        }
    }
    NSString *sign1 = [signArray componentsJoinedByString:@""];
    NSString *sign2 = [NSString stringWithFormat:@"%@%@%@",KEY,sign1,KEY];
    NSString *sign3 = [self MD5ForUpper32Bate:sign2];
    return sign3;
}
-(NSString *)shengxupaixu:(NSDictionary *)dic{
    NSMutableDictionary * newdic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [newdic removeObjectForKey:@"sign"];
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
//        NSString * str = [NSString stringWithFormat:@"%@",valueArray[i]];
//        if (str.length == 0) {
//            continue;
//        }
//        if ([valueArray[i] isKindOfClass:[NSNull class]]) {
//            continue;
//        }
        if ([valueArray[i] isKindOfClass:[NSArray class]]) {
            NSString *keyValueStr = [self paixu:valueArray[i]];//NSString stringWithFormat:@"%@%@",sortArray[i],[valueArray[i] mj_JSONString]  [self paixu:valueArray[i]]
            [signArray addObject:keyValueStr];
        }else{
            NSString *keyValueStr = [NSString stringWithFormat:@"%@%@",sortArray[i],valueArray[i]];
            [signArray addObject:keyValueStr];
        }
    }
    NSString *sign1 = [signArray componentsJoinedByString:@""];
    NSString *sign2 = [NSString stringWithFormat:@"%@%@%@",KEY,sign1,KEY];
    NSLog(@"sign:%@",sign2);
    NSString *sign3 = [self MD5ForUpper32Bate:sign2];
    return sign3;
}
-(NSString *)paixu:(NSArray *)array{
    NSString * str = @"";
    for (NSDictionary * dic in array) {
        NSMutableDictionary * newdic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        [newdic removeObjectForKey:@"sign"];
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
            if ([valueArray[i] isKindOfClass:[NSArray class]]) {
                NSString *keyValueStr = [NSString stringWithFormat:@"%@:%@",sortArray[i],[valueArray[i] mj_JSONString]];
                [signArray addObject:keyValueStr];
            }else{
                NSString *keyValueStr = [NSString stringWithFormat:@"%@:%@",sortArray[i],valueArray[i]];
                [signArray addObject:keyValueStr];
            }
        }
        NSString *sign1 = [signArray componentsJoinedByString:@","];
        NSString * sign2 = [NSString stringWithFormat:@"{%@}",sign1];
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",sign2]];
    }
    NSString *newstr = [str substringToIndex:str.length - 1];
//    str = [str stringByAppendingFormat:@"[%@]",str];
    return [NSString stringWithFormat:@"[%@]",newstr];
}
#pragma mark - MD5加密 32位 大写
- (NSString *)MD5ForUpper32Bate:(NSString *)str{
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}
/**token 过期*/
-(void)tokenExpired
{
//UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
//    rootViewController.navigationController pushViewController:(nonnull UIViewController *) animated:(BOOL)

}
@end
