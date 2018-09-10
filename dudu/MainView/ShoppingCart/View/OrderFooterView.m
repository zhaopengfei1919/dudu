//
//  OrderFooterView.m
//  dudu
//
//  Created by apple on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "OrderFooterView.h"
#import "CouponViewController.h"
@interface OrderFooterView()<UITextFieldDelegate>

@end
@implementation OrderFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.RemarkTF resignFirstResponder];
    return YES;
}
- (IBAction)chosenGift:(id)sender {
}
- (IBAction)chosenCoupon:(id)sender {
    id object = [self nextResponder];
    while (![object isKindOfClass:[UIViewController class]] && object != nil) {
        object = [object nextResponder];
    }
    UIViewController *superController = (UIViewController*)object;
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CouponViewController * coupon = [sb instantiateViewControllerWithIdentifier:@"CouponViewController"];
    coupon.ischosen = YES;
    [superController.navigationController pushViewController:coupon animated:YES];
    WS(weakself);
    coupon.chosencou = ^(CouponModel *model) {
        weakself.coumodel = model;
        if (![model.anHaoType isEqualToString:@"ALL_SHOP"]) {//代金券
            weakself.couponLabel.text = [NSString stringWithFormat:@"%lu元代金券",model.amount];
        }else{//全场满减
            weakself.couponLabel.text = [NSString stringWithFormat:@"满%lu元减%lu",model.lowLimit,model.amount];
        }
    };
}
- (IBAction)chosenJifen:(id)sender {
}
@end
