//
//  SearchViewController.h
//  dudu
//
//  Created by apple on 2018/9/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController{
    UIView * tishiView;
    NSInteger page_number;
    HZSubmitView * submitView;
}
@property (weak, nonatomic) IBOutlet UITextField *SearchTF;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic) NSMutableArray * dataSourse;
@end
