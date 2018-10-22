//
//  ShopCartTableViewCell.h
//  dudu
//
//  Created by apple on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCartTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *selectImage;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) IBOutlet UIImageView *MainImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *GuigeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GuigeLabelWidth;

@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *jia;
@property (weak, nonatomic) IBOutlet UIButton *jian;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;

@property (weak, nonatomic) IBOutlet UILabel *promotionLabel;

@property (strong,nonatomic) HomeModel * model;
@end
