//
//  OrderListTableViewCell.h
//  dudu
//
//  Created by apple on 2018/9/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *CountLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *ImageScroll;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceTop;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *Price2Label;

@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn1;

@property (strong,nonatomic) NSDictionary * dic;
@end
