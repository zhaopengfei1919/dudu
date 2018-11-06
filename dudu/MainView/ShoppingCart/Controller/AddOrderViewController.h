//
//  AddOrderViewController.h
//  dudu
//
//  Created by apple on 2018/8/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderHeaderView.h"
#import "OrderFooterView.h"

@interface AddOrderViewController : UIViewController{
    CGFloat _currentKeyboardH;
    CGFloat _transformY;
    NSInteger usedpoint;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottom;

@property (strong,nonatomic) NSDictionary * data;
@property (strong,nonatomic) NSMutableArray * dataSourse;
@property (strong,nonatomic) OrderHeaderView * headerView;
@property (strong,nonatomic) OrderFooterView * footerView;

@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;
- (IBAction)SurePay:(id)sender;
@property (strong,nonatomic) NSArray * listArray;
@end
