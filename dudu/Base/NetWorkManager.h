//
//  NetWorkManager.h
//  Network
//
//  Created by 枫 on 2017/5/17.
//  Copyright © 2017年 LW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
typedef enum {
    GET,
    POST,
    PUT,
    DELETE,
    HEAD
} HTTPMethod;

/**
 *  请求成功回调
 */
typedef void(^successBlock)(id responseObject);

/**
 *  请求错误回调
 */
typedef void(^errorBlock)(id requestRrror);

@interface NetWorkManager : AFHTTPSessionManager

+(NetWorkManager *)sharedManager;

/**
 网络请求方法

 @param method       请求类型
 @param url          请求接口
 @param parameters   请求参数
 @param success      请求成功回调方法
 @param requestRrror 请求错误回调方法
 */
+(void)requestWithMethod:(HTTPMethod)method Url:(NSString *)url Parameters:(id)parameters success:(successBlock)success requestRrror:(errorBlock)requestRrror;


@end
