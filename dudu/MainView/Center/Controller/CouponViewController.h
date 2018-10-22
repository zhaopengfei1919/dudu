//
//  CouponViewController.h
//  dudu
//
//  Created by apple on 2018/8/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^chosenCoupon)(CouponModel * model);

@interface CouponViewController : UIViewController{
    NSInteger status;
    UIView * tishiView;
    
    BOOL isgotocart;
}
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
- (IBAction)btnclick:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic) NSMutableArray * dataSourse;

@property (copy,nonatomic) chosenCoupon chosencou;
@property (assign) BOOL ischosen;
@end
