//
//  HomeModel.m
//  dudu
//
//  Created by apple on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}
- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}



- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}
@end
