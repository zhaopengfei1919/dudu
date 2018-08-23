//
//  HomeViewController.h
//  dudu
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseNavigationController.h"
#import "HomeHeader.h"

@interface HomeViewController : UIViewController{
    HomeHeader * header;
}
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic) NSMutableArray * dataSourse;
@property (strong,nonatomic) NSMutableArray * promotionSourse;
@property (strong,nonatomic) NSMutableArray * bannerList;

@end
