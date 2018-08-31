//
//  addressModel.m
//  dudu
//
//  Created by apple on 2018/8/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "addressModel.h"

@implementation addressModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             ,@"isdefault":@"default"};
}
@end
