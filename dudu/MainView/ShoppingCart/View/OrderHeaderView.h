//
//  OrderHeaderView.h
//  dudu
//
//  Created by apple on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChosenTimeAndStyle.h"

@interface OrderHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIButton *chosenBtn;
- (IBAction)chosenaddress:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (IBAction)chosenTime:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *payLabel;
- (IBAction)chosenPay:(id)sender;

@property (assign) NSNumber * addressID;
@property (strong,nonatomic) NSString * day;
@property (strong,nonatomic) NSString * time;
@property (assign) NSNumber * payID;

@property (strong,nonatomic) ChosenTimeAndStyle * chosenView;

@property (strong,nonatomic) NSArray * timeArray;
@property (strong,nonatomic) NSArray * payArray;
@end
