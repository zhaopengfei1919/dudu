//
//  TuiKuangTableViewCell.h
//  dudu
//
//  Created by apple on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuiKuangModel.h"

@interface TuiKuangTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *OrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *kuangScroll;

@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;

@property (strong,nonatomic) NSDictionary * dic;
@property (strong,nonatomic) NSMutableArray * array;
@end
