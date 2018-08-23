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

@interface AddOrderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong,nonatomic) NSMutableArray * dataSourse;
@property (strong,nonatomic) OrderHeaderView * headerView;
@property (strong,nonatomic) OrderFooterView * footerView;
@end
