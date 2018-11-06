//
//  CategoryTableViewCell.h
//  dudu
//
//  Created by apple on 2018/8/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface CategoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Image;
@property (weak, nonatomic) IBOutlet UIImageView *SalesOutImage;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *GuigeLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GuiGeLabelWidth;

@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weightLabelWidth;


@property (weak, nonatomic) IBOutlet UIButton *CartBtn;

@property (weak, nonatomic) IBOutlet UILabel *KucunLabel;





@property (strong,nonatomic) HomeModel * model;
@end
