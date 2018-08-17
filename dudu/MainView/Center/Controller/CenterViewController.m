//
//  CenterViewController.m
//  dudu
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CenterViewController.h"
#import "LoginViewController.h"

@interface CenterViewController ()

@end

@implementation CenterViewController
-(void)userInfo{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:[FYUser userInfo].token forKey:@"token"];
    
    [NetWorkManager requestWithMethod:POST Url:userinfo Parameters:paraDic success:^(id responseObject) {

    } requestRrror:^(id requestRrror) {

    }];
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if ([FYUser userInfo].token.length > 0) {
        [self.loginBtn setTitle:@"退出登录" forState:0];
        [self userInfo];
    }else
        [self.loginBtn setTitle:@"点击登录" forState:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.ScrollTop.constant = - StatusHeight;
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)login:(id)sender {
    if ([FYUser userInfo].token.length > 0) {
        
    }else{
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController * login = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:login animated:YES completion:^{
            
        }];
    }
}
@end
