//
//  OrderFooterView.h
//  dudu
//
//  Created by apple on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChosenTimeAndStyle.h"

@interface OrderFooterView : UIView

@property (weak, nonatomic) IBOutlet UILabel *GiftLabel;
- (IBAction)chosenGift:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *giftBtn;

@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
- (IBAction)chosenCoupon:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *CouponBtn;


@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
- (IBAction)chosenJifen:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *jifenBtn;

@property (weak, nonatomic) IBOutlet UILabel *AllPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *yunfeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *yajinLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponMoney;
@property (weak, nonatomic) IBOutlet UILabel *jifenMoney;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;
@property (weak, nonatomic) IBOutlet UILabel *promotionMoney;
@property (weak, nonatomic) IBOutlet UITextField *RemarkTF;

@property (strong,nonatomic) CouponModel * coumodel;

@property (strong,nonatomic) ChosenTimeAndStyle * chosenView;
@property (strong,nonatomic) NSArray * giftArray;
@property (strong,nonatomic) NSString * giftid;
@end
