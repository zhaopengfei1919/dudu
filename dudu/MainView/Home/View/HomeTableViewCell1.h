//
//  HomeTableViewCell1.h
//  dudu
//
//  Created by apple on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface HomeTableViewCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Image;
@property (weak, nonatomic) IBOutlet UIButton *IsCoupon;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ConteneLabel;
@property (weak, nonatomic) IBOutlet UILabel *GuiGeLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *CartBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GuigeLabelWidth;



@property (strong,nonatomic) HomeModel * model;
@end
