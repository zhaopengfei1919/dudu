//
//  pingjiaViewController.h
//  dudu
//
//  Created by apple on 2018/9/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingBar.h"

@interface pingjiaViewController : UIViewController{
    RatingBar * Start1;
    RatingBar * Start2;
    NSInteger statNum1;
    NSInteger statNum2;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MainViewHeight;

@property (weak, nonatomic) IBOutlet RatingBar *Stat1;
@property (weak, nonatomic) IBOutlet RatingBar *Stat2;

@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *RemarkTV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GoodsViewHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *GoodsScroll;

- (IBAction)Sure:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *SureBtn;

@property (strong,nonatomic) NSArray * goodsArray;
@property (strong,nonatomic) NSString * orderid;

@property (strong,nonatomic) NSMutableArray * dataSourse;
@property (strong,nonatomic) NSDictionary * data;
@end
