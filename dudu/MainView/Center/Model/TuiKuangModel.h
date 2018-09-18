//
//  TuiKuangModel.h
//  dudu
//
//  Created by apple on 2018/9/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TuiKuangModel : NSObject

@property (assign) NSInteger quantity;//退筐的数量
@property (assign) float totalPrice;//退筐小计
@property (assign) NSNumber * boxId;//筐ID
@property (assign) NSString * boxName;//筐名称
@property (assign) NSString * boxCode;//筐编号
@property (assign) NSNumber * boxPrice;//筐单价

@end
