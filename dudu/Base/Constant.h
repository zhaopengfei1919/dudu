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


//获取该区域的子区域
#define areaList @"area.listChildArea"
//用户信息
#define userinfo @"member.get"
//我的优惠券
#define MyCoupon @"member.getAnhao"
//绑定业务员
#define BingSalesMan @"member.bindSalesMan"
//解绑业务员
#define CancelSalesMan @"member.cancleSalesMan"
//会员业务员
#define MySalesMan @"member.getSalesMan"
//我的地址
#define MyAddress @"member.getReceiver"
//新增地址
#define Addaddress @"member.addReceiver"
//更新地址
#define UpdetaAddress @"member.updateReceiver"
//删除地址
#define DeleteAddress @"member.deleteReceiver"

//促销栏位
#define Promotion @"promotion.getAllPromotion"
//促销明细
#define PromotionDetail @"promotion.getPromotionDetail"

//首页热卖
#define HotProduce @"product.getHotProduct"
//一级分类信息
#define GETRootProduce @"product.getRootProductCategory"
//二级分类信息
#define GETProduce @"product.getProductByCategoryId"
//根据产品id获取产品具体信息
#define GoodsDetail @"product.getProductDetailById"
//根据产品规格获取产品具体信息
#define GetProductDetail @"product.getProductDetailByProductSpec"


//首页广告位
#define AdList @"ad.getAdPosition"

//我要退筐
#define OrderBox @"order.box.list"

//加入购物车
#define CartAdd @"cart.addProduct"
//购物车清空
#define CartClear @"cart.clear"
//购物车数量
#define CartCount @"cart.cartCount"
//购物车列表
#define CartList @"cart.getProducts"
//删除购物车商品
#define CartDelete @"cart.delProduct"
//修改购物车数量
#define CartChangeCount @"cart.mergeQty"
//结算订单
#define CheckOrder @"cart.payProducts"
//收货时间
#define DeliveryTimes @"cart.list.deliverytimes"
//支付方式
#define PayStyle @"cart.list.payfunctions"




#endif
#endif /* Constant_h */
