//
//  PromotionViewController.h
//  dudu
//
//  Created by apple on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromotionViewController : UIViewController{
    UIView * tishiView;
}


@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong,nonatomic) NSMutableArray * dataSourse;

@property (strong,nonatomic) NSNumber * ID;
@property (strong,nonatomic) NSString * imageurl;
@end
