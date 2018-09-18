//
//  OrderDetailViewController.h
//  dudu
//
//  Created by apple on 2018/9/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong,nonatomic) NSMutableArray * dataSourse;
@property (strong,nonatomic) NSString * orderid;

@property (strong,nonatomic) NSDictionary * data;
@end
