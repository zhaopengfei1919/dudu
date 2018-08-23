//
//  CategoryViewController.h
//  dudu
//
//  Created by apple on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UIViewController{
    NSInteger Num;
    NSInteger Rownum;
    NSInteger Page;
    UIView * tishiView;
}

@property (weak, nonatomic) IBOutlet UITableView *table1;
@property (weak, nonatomic) IBOutlet UITableView *table2;

@property (weak, nonatomic) IBOutlet UILabel *tishiLabel;
@property (weak, nonatomic) IBOutlet UIView *tishi;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tishiHeight;

- (IBAction)cartClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *SureBtn;
- (IBAction)sure:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *CountBtn;



@property (strong,nonatomic) NSMutableArray * dataSourse1;
@property (strong,nonatomic) NSMutableArray * dataSourse2;
@property (strong,nonatomic) NSMutableArray * hotProduce;
@end
