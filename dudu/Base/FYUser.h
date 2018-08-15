//
//  FYUser.h
//  FanYou
//
//  Created by apple on 2018/6/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>

@interface FYUser : NSObject{
    sqlite3 *db;
    
}

+(FYUser*)userInfo;
@property (nonatomic, readonly) NSNumber *userId;
@property (nonatomic, readonly) NSString *sign;
@property (nonatomic, readonly) NSDictionary * __nonnull userInfo;

-(BOOL)isphonenumberwoth:(NSString *)phone;



- (NSMutableArray *)getProvince;
- (NSMutableArray *)getCity:(NSString *)pcode;
- (NSMutableArray *)getDistrict:(NSString *)pcode;
@end
