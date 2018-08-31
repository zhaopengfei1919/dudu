//
//  GoodsModel.h
//  dudu
//
//  Created by apple on 2018/8/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject
@property (assign) NSNumber * ID;//id
@property (strong,nonatomic) NSString * name;//名称
@property (strong,nonatomic) NSString * fullName;//名称
@property (strong,nonatomic) NSString * image;//图片
@property (strong,nonatomic) NSString * introduction;//介绍
@property (strong,nonatomic) NSString * memo;//备注
@property (assign) float price;//id
@property (assign) NSInteger stock;
@property (strong,nonatomic) NSArray * productImages;
@property (strong,nonatomic) NSArray * specifications;//规格数组
@end
