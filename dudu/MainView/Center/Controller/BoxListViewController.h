//
//  BoxListViewController.h
//  dudu
//
//  Created by apple on 2018/9/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoxListViewController : UIViewController{
    UIView * tishiView;
    NSInteger page_number;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic) NSMutableArray * dataSourse;
@end
