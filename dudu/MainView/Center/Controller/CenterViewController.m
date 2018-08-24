//
//  CenterViewController.m
//  dudu
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CenterViewController.h"
#import "LoginViewController.h"
#import "CategoryViewController.h"

@interface CenterViewController ()

@end

@implementation CenterViewController
-(void)userInfo{
//    WS(weakself);
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
    self.backImage.layer.cornerRadius = 33;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpTocategoryController) name:@"pushcategory" object:nil];

    // Do any additional setup after loading the view.
}
- (void)jumpTocategoryController{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushcategory" object:nil];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CategoryViewController * category = [sb instantiateViewControllerWithIdentifier:@"CategoryViewController"];
    [self.navigationController pushViewController:category animated:YES];
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

- (IBAction)ChosenSalesman:(id)sender {
    if ([FYUser userInfo].token.length > 0) {
        [self performSegueWithIdentifier:@"mysalesman" sender:nil];
    }else{
        [self loginclick];
    }
}

- (IBAction)login:(id)sender {
    if ([FYUser userInfo].token.length > 0) {
        
    }else{
        [self loginclick];
    }
}
-(void)loginclick{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController * login = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:login animated:YES completion:^{
        
    }];
}
@end
