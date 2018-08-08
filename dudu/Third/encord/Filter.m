//
//  Filter.m
//  TongXiangtrip
//
//  Created by 肖恒 on 13-8-31.
//  Copyright (c) 2013年 肖恒. All rights reserved.
//

#import "Filter.h"

@implementation Filter


+ (NSString *)filter:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfString:@"+" withString:@""];
}

@end
