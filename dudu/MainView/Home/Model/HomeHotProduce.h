//
//  HomeHotProduce.h
//  dudu
//
//  Created by apple on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeHotProduce : NSObject
@property (assign) NSNumber * ID;//id
@property (strong,nonatomic) NSString * name;//名称
@property (strong,nonatomic) NSArray * products;
@property (assign) NSString * showType;//首页排列1横2竖
@property (strong,nonatomic) NSArray * subProductCategory;
@end
