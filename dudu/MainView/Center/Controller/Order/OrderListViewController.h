//
//  OrderListViewController.h
//  dudu
//
//  Created by apple on 2018/9/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListViewController : UIViewController{
    NSInteger pagenum;
    UIView * tishiView;
    UIButton * remberBtn;
}
@property (weak, nonatomic) IBOutlet UIButton *AllBtn;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic) NSMutableArray * dataSourse;

- (IBAction)statusClick:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LingLeft;

@property (assign) NSString * status;


@end
