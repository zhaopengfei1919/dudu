//
//  OrderHeaderView.m
//  dudu
//
//  Created by apple on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "OrderHeaderView.h"

@implementation OrderHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 
 */
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self deliverytime];
    [self paystyle];
}

-(void)deliverytime{
    //    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;

    [NetWorkManager requestWithMethod:POST Url:DeliveryTimes Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject safeObjectForKey:@"code"];
        NSLog(@"%@",responseObject);
        if ([code intValue] == 0) {
            self.timeArray = [responseObject safeObjectForKey:@"data"];
        }
    } requestRrror:^(id requestRrror) {
        
    }];
}
-(void)paystyle{
    //    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    
    [NetWorkManager requestWithMethod:POST Url:PayStyle Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject safeObjectForKey:@"code"];
        NSLog(@"%@",responseObject);
        if ([code intValue] == 0) {
            self.payArray = [responseObject safeObjectForKey:@"data"];
        }
    } requestRrror:^(id requestRrror) {
        
    }];
}

- (IBAction)chosenaddress:(id)sender {
}
- (IBAction)chosenTime:(id)sender {
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    
    self.chosenView = [[[NSBundle mainBundle] loadNibNamed:@"ChosenTimeAndStyle" owner:self options:nil] objectAtIndex:0];
    self.chosenView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.chosenView.tyle = @"time";
    self.chosenView.array = self.timeArray;
    [window addSubview:self.chosenView];
    WS(weakself);
    [self.chosenView setChosenBlock:^(NSDictionary *dic) {
        weakself.timeLabel.text = [NSString stringWithFormat:@"%@ %@",[dic safeObjectForKey:@"day"],[dic safeObjectForKey:@"time"]];
    }];
}
- (IBAction)chosenPay:(id)sender {
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    
    self.chosenView = [[[NSBundle mainBundle] loadNibNamed:@"ChosenTimeAndStyle" owner:self options:nil] objectAtIndex:0];
    self.chosenView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.chosenView.tyle = @"pay";
    self.chosenView.array = self.payArray;
    [window addSubview:self.chosenView];
    WS(weakself);
    [self.chosenView setChosenBlock:^(NSDictionary *dic) {
        weakself.payLabel.text = [dic safeObjectForKey:@"name"];
    }];
}
@end
