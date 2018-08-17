//
//  CenterViewController.h
//  dudu
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ScrollTop;

- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;



@end
