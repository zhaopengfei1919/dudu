//
//  Constant.h
//  FanYou
//
//  Created by apple on 2018/6/11.
//  Copyright © 2018年 apple. All rights reserved.
//
#ifdef __OBJC__
#import <UIKit/UIKit.h>

#ifndef Constant_h
#define Constant_h

#define HTTPURL @"http://47.100.224.21/api/gateway.jhtml"
#define APPKEY @"appid1236587459"
//#define APPKEY @"asdsaj89jkklasdklhhkllllj"
#define SIGNKEY @"asdsaj89jkklasdklhhkllllj"

//登录接口
#define Login @"token.get"
//发送验证码
#define Sendcode @"token.smssend"
//用户信息
#define userinfo @"member.get"
//用户详情
#define UserDetail @"user/detail"
//上传头像
#define SetAvatars @"user/set-avatars"



//首页热卖
#define HotProduce @"product.getHotProduct"
//首页广告位
#define AdList @"ad.getAdPosition"
//促销栏位
#define Promotion @"promotion.getAllPromotion"
//促销明细
#define PromotionDetail @"promotion.getPromotionDetail"
//我的店铺
#define CartCount @"cart.cartCount"

//一级分类信息
#define GETRootProduce @"product.getRootProductCategory"
//二级分类信息
#define GETProduce @"product.getProductByCategoryId"


//收货时间
#define DeliveryTimes @"cart.list.deliverytimes"
//支付方式
#define PayStyle @"cart.list.payfunctions"


#endif
#endif /* Constant_h */
