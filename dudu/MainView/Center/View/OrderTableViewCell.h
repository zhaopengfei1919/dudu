//
//  OrderTableViewCell.h
//  dudu
//
//  Created by apple on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *MainImage;

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *GuigeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GuigeLabelWidth;
@property (weak, nonatomic) IBOutlet UILabel *GiftLabel;

@property (weak, nonatomic) IBOutlet UILabel *UnitPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *CountLabel;

@property (weak, nonatomic) IBOutlet UILabel *ActuallyLabel;

@property (strong,nonatomic) HomeModel * model;
@end
