//
//  BoxViewController.h
//  dudu
//
//  Created by apple on 2018/8/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoxViewController : UIViewController{
    UIView * tishiView;
    NSInteger page_number;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic) NSMutableArray * dataSourse;
@property (strong,nonatomic) UIButton * sureBtn;
@property (strong,nonatomic) NSMutableArray * selectArray;
@property (strong,nonatomic) NSMutableArray * changeArray;
@end
