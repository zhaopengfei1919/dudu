//
//  UserModel.h
//  dudu
//
//  Created by apple on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (strong,nonatomic) NSString * mobile;//手机号
@property (strong,nonatomic) NSString * smallHeadImage;//用户头像
@property (strong,nonatomic) NSString * memberRank;//会员等级
@property (strong,nonatomic) NSString * username;//用户名
@property (strong,nonatomic) NSNumber * point;//积分
@property (strong,nonatomic) NSString * sex;//性别
@property (assign) BOOL isHasSalesman;//是否绑定业务员
@property (strong,nonatomic) NSString * salesmanName;//业务员姓名
@property (strong,nonatomic) NSString * salesmanCode;//业务员编号
@property (strong,nonatomic) NSNumber * noPayOrderNumber;//待付款订单数量
@property (strong,nonatomic) NSNumber * noRecevedOrder;//待收货订单数量
@property (strong,nonatomic) NSNumber * hasPayOrder;//已完成订单数量
@property (strong,nonatomic) NSNumber * voucherNumber;//优惠券数量
@end
