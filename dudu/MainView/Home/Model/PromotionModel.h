//
//  PromotionModel.h
//  dudu
//
//  Created by apple on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromotionModel : NSObject
@property (assign) NSNumber * ID;//id
@property (strong,nonatomic) NSString * name;//名称
@property (strong,nonatomic) NSString * introduction;//活动介绍
@property (strong,nonatomic) NSString * mobileImage;
@property (strong,nonatomic) NSString * smallMobileImage;
@property (strong,nonatomic) NSArray * productInfoList;

@end
