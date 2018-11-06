//
//  CouponModel.h
//  dudu
//
//  Created by apple on 2018/8/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponModel : NSObject
@property (assign) NSNumber * ID;
@property (strong,nonatomic) NSString * anHaoType;//分类
@property (assign) NSUInteger lowLimit;//最低下单金额，即满x减y中的x
@property (assign) NSUInteger amount;//面额，即满x减y中的y
@property (strong,nonatomic) NSString * no;//卡号
@property (strong,nonatomic) NSString * anhao;//暗号
@property (strong,nonatomic) NSString * startDate;//开始日期
@property (strong,nonatomic) NSString * endDate;//结束日期
@property (strong,nonatomic) NSString * anHaoStatus;//状态
@end
