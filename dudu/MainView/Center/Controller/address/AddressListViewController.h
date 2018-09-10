//
//  AddressListViewController.h
//  dudu
//
//  Created by apple on 2018/8/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ChosenAddress)(addressModel * model);

@interface AddressListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic) NSMutableArray * dataSourse;

@property (copy,nonatomic) ChosenAddress chosenadd;
@property (assign) BOOL ischosen;
@end
