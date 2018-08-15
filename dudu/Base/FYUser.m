//
//  FYUser.m
//  FanYou
//
//  Created by apple on 2018/6/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FYUser.h"
#import "HZProvince.h"
#import "HZDistrict.h"
#import "HZCity.h"

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
- (NSString *)sign
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *result = [defaults objectForKey:@"sign"];
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




- (NSMutableArray *)getProvince{
    NSString *database_path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"s3db"];
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    
    NSString *sqlQuery = @"SELECT * FROM province";
    sqlite3_stmt * statement;
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            HZProvince *province = [[HZProvince alloc] init];
            
            char *name = (char*)sqlite3_column_text(statement, 2);
            NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);  //GBK编码转换
            NSString *nsNameStr = [NSString stringWithCString:name encoding:gbkEncoding];
            
            int ids = sqlite3_column_int(statement, 0);
            
            char *code = (char*)sqlite3_column_text(statement, 1);
            NSString *codeStr = [[NSString alloc]initWithUTF8String:code];
            
            province.ids = ids;
            province.name = nsNameStr;
            province.code = codeStr;
            [arr addObject:province];
            //NSLog(@"name:%@  age:%d  address:%@",nsNameStr,ids, codeStr);
        }
    }
    sqlite3_close(db);
    return arr;
}
- (NSMutableArray *)getCity:(NSString *)pcode{
    NSString *database_path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"s3db"];
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM city WHERE pcode = %@",pcode];
    sqlite3_stmt * statement;
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            HZDistrict *province = [[HZDistrict alloc] init];
            
            char *name = (char*)sqlite3_column_text(statement, 2);
            NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);  //GBK编码转换
            NSString *nsNameStr = [NSString stringWithCString:name encoding:gbkEncoding];
            
            int ids = sqlite3_column_int(statement, 0);
            
            char *code = (char*)sqlite3_column_text(statement, 1);
            NSString *codeStr = [[NSString alloc]initWithUTF8String:code];
            
            char *pcode = (char*)sqlite3_column_text(statement, 1);
            NSString *pcodeStr = [[NSString alloc]initWithUTF8String:pcode];
            
            
            province.ids = ids;
            province.name = nsNameStr;
            province.code = codeStr;
            province.pcode = pcodeStr;
            [arr addObject:province];
        }
    }
    sqlite3_close(db);
    return arr;
}
- (NSMutableArray *)getDistrict:(NSString *)pcode{
    NSString *database_path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"s3db"];
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM district WHERE pcode = %@",pcode];
    sqlite3_stmt * statement;
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            HZDistrict *province = [[HZDistrict alloc] init];
            
            char *name = (char*)sqlite3_column_text(statement, 2);
            NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);  //GBK编码转换
            NSString *nsNameStr = [NSString stringWithCString:name encoding:gbkEncoding];
            
            int ids = sqlite3_column_int(statement, 0);
            
            char *code = (char*)sqlite3_column_text(statement, 1);
            NSString *codeStr = [[NSString alloc]initWithUTF8String:code];
            
            char *pcode = (char*)sqlite3_column_text(statement, 1);
            NSString *pcodeStr = [[NSString alloc]initWithUTF8String:pcode];
            
            
            province.ids = ids;
            province.name = nsNameStr;
            province.code = codeStr;
            province.pcode = pcodeStr;
            [arr addObject:province];
        }
    }
    sqlite3_close(db);
    return arr;
}

@end
