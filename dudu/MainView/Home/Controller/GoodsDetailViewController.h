//
//  GoodsDetailViewController.h
//  dudu
//
//  Created by apple on 2018/8/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@interface GoodsDetailViewController : UIViewController{
    int GoodsCount;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MainViewHeight;

@property (weak, nonatomic) IBOutlet UIImageView *MainImage;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;

@property (weak, nonatomic) IBOutlet UIView *GuiGeView;
- (IBAction)jian:(id)sender;
- (IBAction)jia:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GuigeViewHeight;


@property (weak, nonatomic) IBOutlet UITextView *descTextView;

- (IBAction)gotoCart:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *CountLabel;
- (IBAction)AddCart:(id)sender;

@property (assign) NSNumber * GoodsID;
@property (strong,nonatomic) GoodsModel * model;

@property (assign) NSString * firstID;
@property (assign) NSString * secondID;
@end
