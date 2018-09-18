//
//  OrderHeaderView.m
//  dudu
//
//  Created by apple on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "OrderHeaderView.h"
#import "AddressListViewController.h"

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
        WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;

    [NetWorkManager requestWithMethod:POST Url:DeliveryTimes Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject safeObjectForKey:@"code"];
//        NSLog(@"%@",responseObject);
        if ([code intValue] == 0) {
            weakself.timeArray = [responseObject safeObjectForKey:@"data"];
        }
    } requestRrror:^(id requestRrror) {
        
    }];
}
-(void)paystyle{
        WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    
    [NetWorkManager requestWithMethod:POST Url:PayStyle Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject safeObjectForKey:@"code"];
//        NSLog(@"%@",responseObject);
        if ([code intValue] == 0) {
            weakself.payArray = [responseObject safeObjectForKey:@"data"];
        }
    } requestRrror:^(id requestRrror) {
        
    }];
}

- (IBAction)chosenaddress:(id)sender {
    id object = [self nextResponder];
    while (![object isKindOfClass:[UIViewController class]] && object != nil) {
        object = [object nextResponder];
    }
    UIViewController *superController = (UIViewController*)object;
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddressListViewController * address = [sb instantiateViewControllerWithIdentifier:@"AddressListViewController"];
    address.ischosen = YES;
    [superController.navigationController pushViewController:address animated:YES];
    WS(weakself);
    address.chosenadd = ^(addressModel *model) {
        weakself.addressID = model.ID;
        [weakself.chosenBtn setTitle:@"" forState:0];
        [weakself.chosenBtn setBackgroundColor:[UIColor clearColor]];
        weakself.nameLabel.text = [NSString stringWithFormat:@"%@ %@",model.consignee,model.phone];
        NSDictionary * areaInfo =model.areaInfo;
        weakself.areaLabel.text = [NSString stringWithFormat:@"上海市%@%@",[areaInfo safeObjectForKey:@"name"],model.address];
    };
}
- (IBAction)chosenTime:(id)sender {
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    
    self.chosenView = [[[NSBundle mainBundle] loadNibNamed:@"ChosenTimeAndStyle" owner:self options:nil] objectAtIndex:0];
    self.chosenView.frame = window.bounds;
    self.chosenView.tyle = @"time";
    self.chosenView.array = self.timeArray;
    [window addSubview:self.chosenView];
    WS(weakself);
    [self.chosenView setChosenBlock:^(NSDictionary *dic) {
        weakself.day = [dic safeObjectForKey:@"day"];
        weakself.time = [dic safeObjectForKey:@"time"];
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
        weakself.payID = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"id"]];
    }];
}
@end
