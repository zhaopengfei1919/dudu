//
//  ShopCartViewController.h
//  dudu
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCartViewController : UIViewController{
    UIView * tishiView;
    UILabel * tishilabel;
}
@property (strong,nonatomic) NSDictionary * data;
@property (strong,nonatomic) NSMutableArray * dataSourse;
@property (strong,nonatomic) NSMutableArray * selectSourse;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet UIView *tishi;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tishiHeight;
@property (weak, nonatomic) IBOutlet UILabel *tishiLabel;

- (IBAction)allchosen:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *allchosenImage;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *yaJinLabel;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)sure:(id)sender;


@property (strong,nonatomic) NSArray * listarray;
@end
