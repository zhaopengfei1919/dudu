//
//  QRView.h
//  CSHScanDemo
//
//  Created by hh on 15/12/24.
//  Copyright © 2015年 陈胜辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRMenu.h"

@protocol QRViewDelegate <NSObject>

-(void)scanTypeConfig:(QRItem *)item;

@end
@interface QRView : UIView
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}


@property (nonatomic, weak) id<QRViewDelegate> delegate;
/**
 *  透明的区域
 */
@property (nonatomic, assign) CGSize transparentArea;
@end
