//
//  HomeTableViewCell2.h
//  dudu
//
//  Created by apple on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface HomeTableViewCell2 : UITableViewCell{
    HZSubmitView * submitView;
}
@property (weak, nonatomic) IBOutlet UIView *View1;
@property (weak, nonatomic) IBOutlet UIButton *isCoupon1;
@property (weak, nonatomic) IBOutlet UIImageView *Image1;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *ContentLabel1;
@property (weak, nonatomic) IBOutlet UILabel *GuigeLabel1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GuiGeLabelWidth1;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weightLabelWidth1;


@property (weak, nonatomic) IBOutlet UILabel *unitPrice1;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel1;
@property (weak, nonatomic) IBOutlet DDButton *CartBtn1;

- (IBAction)gotodetail:(id)sender;
- (IBAction)addcart:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *View2;
@property (weak, nonatomic) IBOutlet UIButton *isCoupon2;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *ContentLabel2;
@property (weak, nonatomic) IBOutlet UILabel *GuigeLabel2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GuigeLabelWidth2;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weightLabelWidth2;


@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel2;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel2;
@property (weak, nonatomic) IBOutlet DDButton *CartBtn2;





@property (strong,nonatomic) NSArray * array;
@end
