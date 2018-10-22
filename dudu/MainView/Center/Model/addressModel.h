//
//  addressModel.h
//  dudu
//
//  Created by apple on 2018/8/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface addressModel : NSObject
@property (assign) NSNumber * ID;
@property (strong,nonatomic) NSString * consignee;//姓名
@property (strong,nonatomic) NSString * phone;//手机号
@property (strong,nonatomic) NSString * province;//省份
@property (strong,nonatomic) NSString * city;//市
@property (strong,nonatomic) NSString * district;//区
//@property (strong,nonatomic) NSDictionary * areaInfo;//区域信息
@property (strong,nonatomic) NSString * address;//详细地址
@property (assign) NSNumber * isdefault;//是否默认
@end
