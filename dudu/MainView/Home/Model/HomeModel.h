//
//  HomeModel.h
//  dudu
//
//  Created by apple on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject

@property (assign) NSNumber * ID;//id
@property (strong,nonatomic) NSString * image;//图片
@property (strong,nonatomic) NSString * name;//名称
@property (assign) float price;//价格
@property (assign) float unitPrice;//单价
@property (strong,nonatomic) NSString * unit;//单位
@property (assign) NSInteger weight;//重量
@property (strong,nonatomic) NSString * packaging;//包装
@property (assign) NSInteger stock;//库存
@property (assign) NSInteger cartNumber;//购物车中数量
@property (assign) NSInteger specificationNumber;//规格数量
@property (assign) BOOL isGift;//是否赠品
@property (strong,nonatomic) NSString * memo;//备注
@property (strong,nonatomic) NSString * tag;//左上角图片
@property (assign) NSInteger boxPrice;//单个筐费
@property (strong,nonatomic) NSString * boxCode;//筐码
@end
