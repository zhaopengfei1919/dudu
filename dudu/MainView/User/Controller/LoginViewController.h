//
//  LoginViewController.h
//  dudu
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *PhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *CodeTF;
- (IBAction)sendSMS:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;


@property (assign) int daojishu;
@property (nonatomic, strong) NSTimer *timer;
@end
