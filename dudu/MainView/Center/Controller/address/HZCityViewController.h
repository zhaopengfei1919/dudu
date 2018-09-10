//
//  HZCityViewController.h
//  DLWebsite
//
//  Created by Xiaoheng on 15/3/4.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZCityViewController : UIViewController
{
    int type;
    NSString *province;
    NSString *city;
    NSString *area;
    
    NSString *provinceid;
    NSString *cityid;
    NSString *areaid;
}
@property (nonatomic, strong) NSArray *array;
@property (strong, nonatomic) UITableView *table;
@end
