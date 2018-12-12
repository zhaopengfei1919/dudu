//
//  JifenDetailViewController.h
//  dudu
//
//  Created by apple on 2018/12/11.
//  Copyright © 2018 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JifenDetailViewController : UIViewController{
    UIView * tishiView;
    NSInteger page_number;
    UserModel * usermodel;
}

@property (weak, nonatomic) IBOutlet UITableView *table;


@property (strong,nonatomic) NSMutableArray * dataSourse;

@end

NS_ASSUME_NONNULL_END
