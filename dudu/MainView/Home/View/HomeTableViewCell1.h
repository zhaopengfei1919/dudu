//
//  HomeTableViewCell1.h
//  dudu
//
//  Created by apple on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
#import "HZSubmitView.h"

@interface HomeTableViewCell1 : UITableViewCell{
    HZSubmitView * submitView;
}
@property (weak, nonatomic) IBOutlet UIImageView *Image;
@property (weak, nonatomic) IBOutlet UIButton *IsCoupon;
@property (weak, nonatomic) IBOutlet UIImageView *CouponImage;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ConteneLabel;
@property (weak, nonatomic) IBOutlet UILabel *GuiGeLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *CartBtn;
- (IBAction)addcart:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GuigeLabelWidth;

@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weightLabelWidth;


@property (strong,nonatomic) HomeModel * model;
@end
