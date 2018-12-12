//
//  JifenModel.h
//  dudu
//
//  Created by apple on 2018/12/11.
//  Copyright © 2018 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JifenModel : NSObject
@property (assign) NSNumber * ID;
@property (strong,nonatomic) NSNumber * memberId;//会员id
@property (strong,nonatomic) NSString * memberName;//会员姓名
@property (strong,nonatomic) NSNumber * point;//积分
@property (strong,nonatomic) NSNumber * beforePoint;//变化前积分
@property (strong,nonatomic) NSNumber * afterPoint;//变化后积分
@property (strong,nonatomic) NSString * type;//类型
@property (strong,nonatomic) NSString * happenDate;//时间
@property (strong,nonatomic) NSNumber * currentPoint;//当前积分
@end

NS_ASSUME_NONNULL_END
