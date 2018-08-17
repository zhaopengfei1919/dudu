//
//  LoginViewController.m
//  dudu
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.LoginBtn.layer.cornerRadius = 3;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.PhoneTF) {
        if (string.length == 0)
            return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.PhoneTF resignFirstResponder];
    [self.CodeTF resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendSMS:(id)sender {
    if (![[FYUser userInfo] isphonenumberwoth:self.PhoneTF.text]){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:self.PhoneTF.text forKey:@"strParam"];
    
    [NetWorkManager requestWithMethod:POST Url:Sendcode Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
            
            weakself.daojishu = 60;
            weakself.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daoshu) userInfo:nil repeats:YES];
            [weakself.timer fire];
            weakself.sendBtn.userInteractionEnabled = NO;
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
- (void)daoshu
{
    self.daojishu --;
    if (self.daojishu == 0) {
        [self.sendBtn setTitle:@"获取验证码" forState:0];
        self.sendBtn.userInteractionEnabled = YES;
        [self.timer invalidate];
        self.timer = nil;
    }else{
        [self.sendBtn setTitle:[NSString stringWithFormat:@"%dS/重新发送",self.daojishu] forState:0];
    }
}
- (IBAction)login:(id)sender {
    if (![[FYUser userInfo] isphonenumberwoth:self.PhoneTF.text]){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:self.PhoneTF.text forKey:@"mobile"];
    [paraDic setObject:self.CodeTF.text forKey:@"messageCode"];
    
    [NetWorkManager requestWithMethod:POST Url:Login Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary * data = [responseObject objectForKey:@"data"];
            [defaults setObject:data forKey:@"UserInfo"];
            [defaults setObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"token"]] forKey:@"token"];
            [defaults synchronize];
            
            [weakself dismissViewControllerAnimated:YES completion:^{
                
            }];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
@end
