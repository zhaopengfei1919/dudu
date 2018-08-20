//
//  QRItem.h
//  CSHScanDemo
//
//  Created by hh on 15/12/24.
//  Copyright © 2015年 陈胜辉. All rights reserved.
//

#import <UIKit/UIKit.h>

//扫描类型
typedef NS_ENUM(NSUInteger, QRItemType) {
    QRItemTypeQRCode = 0,
    QRItemTypeOther,
};


@interface QRItem : UIButton

@property (nonatomic, assign) QRItemType type;

- (instancetype)initWithFrame:(CGRect)frame
                       titile:(NSString *)titile;
@end
