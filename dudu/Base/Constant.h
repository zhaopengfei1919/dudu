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


//一级分类信息
#define GETRootProduce @"ad.getRootProductCategory"
//热门店铺
#define HotShop @"shop/hot-list"
//首页广告位
#define AdList @"ad.getAdPosition"
//店铺列表
#define ShopList @"shop/list"
//商品列表
#define GoodsList @"goods/list"
//我的店铺
#define MYShop @"shop/my-shop"

//设置店铺简介
#define Setdesc @"shop/set-desc"
//我的店铺商品列表
#define GoodsList @"goods/list"
//删除商品
#define GoodsDelete @"goods/delete"
//上传商品
#define GoodsUpload @"goods/upload"
//开店
#define ShopOpen @"shop/open"

//获取默认收货地址
#define GetDefault @"addr/get-default"
//提交订单
#define OrderCreate @"order/create"
//商品信息
#define GoodInfo @"goods/info"
//地址列表
#define AddrList @"addr/list"
//添加地址
#define AddrUpsert @"addr/upsert"
//设置默认地址
#define SetDefault @"addr/set-default"
//删除地址
#define AddrDelete @"addr/delete"
//我的订单数目
#define OrderStatistics @"order/statistics"
//我的订单
#define OrderList @"order/list"
//订单确认收货
#define OrderConfirm @"order/confirm"
//删除订单
#define OrderDelete @"order/delete"
//订单详情
#define OrderDetail @"order/detail"
//提醒发货
#define Hintdeliver @"order/hint-deliver"
//取消订单
#define OrderLose @"order/lose"


//银行卡列表
#define CardList @"user/card-list"
//添加银行卡
#define AddCard @"user/add-card"
//提现到银行卡
#define Withdraw @"user/withdraw"

//转账记录
#define Tranrecord @"user/tran-record"

#endif
#endif /* Constant_h */
