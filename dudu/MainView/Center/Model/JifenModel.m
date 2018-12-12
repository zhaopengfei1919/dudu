//
//  JifenModel.m
//  dudu
//
//  Created by apple on 2018/12/11.
//  Copyright © 2018 apple. All rights reserved.
//

#import "JifenModel.h"

@implementation JifenModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             ,@"isdefault":@"default"};
}
@end
