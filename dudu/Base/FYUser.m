//
//  FYUser.m
//  FanYou
//
//  Created by apple on 2018/6/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FYUser.h"


@implementation FYUser

+(FYUser*)userInfo
{
    static FYUser *_userInfo = nil;
    
    if (nil == _userInfo ) {
        _userInfo = [[self alloc] init];
        
    }
    return _userInfo;
}
- (NSNumber *)userId
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString * result = [defaults objectForKey:UserID];
    if (!result) {
        result = @"";
    }
    return [NSNumber numberWithInt:[result intValue]];
}
- (NSString *)token
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *result = [defaults objectForKey:@"token"];
    if (!result) {
        result = @"";
    }
    return result;
}
- (NSDictionary *)userInfo
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *result = [defaults objectForKey:UserInfo];
    if (!result) {
        result = [NSDictionary dictionaryWithObjectsAndKeys: nil];
    }
    return result;
}

-(BOOL)isphonenumberwoth:(NSString *)phone{
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     * 联通号段正则表达式
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 电信号段正则表达式
     */
    NSString *CT_NUM = @"^((133)|(153)|(177)|(170)|(18[0,1,9]))\\d{8}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:phone];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:phone];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:phone];
    
    if (isMatch1 || isMatch2 || isMatch3) {
        return YES;
    }else{
        return NO;
    }
}

- (CGSize)sizeForString:(NSString *)string withFontSize:(int)sizenumber withWidth:(int)width
{
    UIFont *font = [UIFont systemFontOfSize:sizenumber];
    //设置一个行高上限
    CGSize size = CGSizeMake(width,2000);
    NSDictionary * fontDict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGRect labelsize = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil];
    return labelsize.size;
}





@end
