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
//获取所有一级区域
#define Allarea @"area.listroots"
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
//获取会员id获取会员积分流水
#define JifenDetail @"member.points"

//促销栏位
#define Promotion @"promotion.getAllPromotion"
//促销明细
#define PromotionDetail @"promotion.getPromotionDetail"
//获取首页倒计时信息
#define GetCountdownInfo @"promotion.getCountdownInfo"

//列出当前用户的咨询列表
#define ConsultList @"consult.list"
//发送一条新的咨询问题
#define ConsultSend @"consult.send"

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
//搜搜
#define Search @"product.search"


//首页广告位
#define AdList @"ad.getAdPosition"

//我要退筐
#define OrderBox @"order.box.list"
//生成退筐单
#define ReturnBox @"return.box.create"
//我的退筐单
#define MyReturnBox @"return.box.list"

//取消订单
#define OrderCancel @"order.cancel"
//订单评价
#define OrderComment @"order.getComment"
//订单列表
#define Orderlist @"order.list"
//根据订单编号付款
#define OrderPay @"order.pay"
//保存订单
#define OrderSave @"order.save"
//保存订单评价
#define OrderSaveComment @"order.saveComment"
//订单详情
#define Orderdetail @"order.view"

//加入购物车
#define CartAdd @"cart.addProduct"
//批量加入购物车
#define CartAdds @"cart.addProducts"
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
