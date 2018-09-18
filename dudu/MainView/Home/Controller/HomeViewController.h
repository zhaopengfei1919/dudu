//
//  HomeViewController.h
//  dudu
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseNavigationController.h"
#import "HomeHeader.h"
#import "HomePopup.h"

@interface HomeViewController : UIViewController{
    HomeHeader * header;
    HomePopup * popup;
}
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic) NSMutableArray * dataSourse;
@property (strong,nonatomic) NSMutableArray * promotionSourse;
@property (strong,nonatomic) NSMutableArray * bannerList;

@property (strong,nonatomic) NSDictionary * popupDic;

@end
