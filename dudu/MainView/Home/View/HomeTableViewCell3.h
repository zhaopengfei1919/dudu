//
//  HomeTableViewCell3.h
//  dudu
//
//  Created by apple on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromotionModel.h"

@interface HomeTableViewCell3 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIView *View1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *View1Height;

@property (weak, nonatomic) IBOutlet UIView *View2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *View2Top;

@property (strong,nonatomic) NSArray * array;
@end
