//
//  ScanViewController.h
//  CSHScanDemo
//
//  Created by hh on 15/12/24.
//  Copyright © 2015年 陈胜辉. All rights reserved.
//

#import <UIKit/UIKit.h>

//回调扫描结果
typedef void(^QRUrlBlock)(NSString *url);
@interface ScanViewController : UIViewController


@property (nonatomic, copy) QRUrlBlock qrUrlBlock;

@end
