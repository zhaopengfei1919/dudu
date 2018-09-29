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
#import "OrderListViewController.h"
#import "BoxViewController.h"

@interface CenterViewController ()

@end

@implementation CenterViewController
-(void)userInfo{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:[FYUser userInfo].token forKey:@"token"];
    
    [NetWorkManager requestWithMethod:POST Url:userinfo Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            self->usermodel = [UserModel mj_objectWithKeyValues:[responseObject safeObjectForKey:@"data"]];
            [weakself createUI];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {

    }];
}
-(void)createUI{
    self.PhoneLabel.text = usermodel.mobile;
    self.JifenLabel.text = [NSString stringWithFormat:@"我的积分：%@积分",usermodel.point];
    if (usermodel.memberRank.length > 0) {
        self.LevelLabel.text = usermodel.memberRank;
        self.LevelLabel.hidden = NO;
        self.LevelLabel.layer.cornerRadius = 3;
    }
    if (usermodel.isHasSalesman) {
        self.SalesManLabel.text = [NSString stringWithFormat:@"%@",usermodel.salesmanName];
    }else
        self.SalesManLabel.text = @"请添加您的业务员";
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
//    self.ScrollTop.constant = - StatusHeight;
    self.backImage.layer.cornerRadius = 33;
    
    adjustsScrollViewInsets_NO(self.scroll, self);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taptologin:)];
    [self.headImage addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}
-(void)taptologin:(UITapGestureRecognizer *)tap{
    if ([FYUser userInfo].token.length == 0) {
        [self loginclick];
    }
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
    if ([FYUser userInfo].token.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        return;
    }
    [self performSegueWithIdentifier:@"mysalesman" sender:nil];
    
//    if ([FYUser userInfo].token.length > 0) {
//        [self performSegueWithIdentifier:@"mysalesman" sender:nil];
//    }else{
//        [SVProgressHUD showErrorWithStatus:@"请先登录"];
//        [self loginclick];
//    }
}

- (IBAction)OrderClick:(id)sender {
    if ([FYUser userInfo].token.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        return;
    }
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OrderListViewController * order = [sb instantiateViewControllerWithIdentifier:@"OrderListViewController"];
    UIButton * btn = (UIButton *)sender;
    if (btn.tag == 0) {//0=全部,1=待付款,2=待发货,3=配送中,4=已完成,5=已取消
        order.status = @"0";
    }else if (btn.tag == 1){
        order.status = @"1";
    }else if (btn.tag == 2){
        order.status = @"2";
    }else if (btn.tag == 3){
        order.status = @"3";
    }else if (btn.tag == 4){
        order.status = @"4";
    }else if (btn.tag == 5){
        order.status = @"5";
    }
    [self.navigationController pushViewController:order animated:YES];
}

- (IBAction)chosenCoupon:(id)sender {
    if ([FYUser userInfo].token.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先登录"];    
        return;
    }
    [self performSegueWithIdentifier:@"gotocoupon" sender:nil];
}

- (IBAction)myaddress:(id)sender {
    if ([FYUser userInfo].token.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        return;
    }
    [self performSegueWithIdentifier:@"gotoaddress" sender:nil];
}

- (IBAction)myTuikuan:(id)sender {
    if ([FYUser userInfo].token.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        return;
    }
    [self performSegueWithIdentifier:@"tuikuang" sender:nil];
}

- (IBAction)myTuikuang:(id)sender {
    if ([FYUser userInfo].token.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        return;
    }
    [self performSegueWithIdentifier:@"tuikuangList" sender:nil];
}

- (IBAction)login:(id)sender {
    if ([FYUser userInfo].token.length > 0) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@{} forKey:@"UserInfo"];
        [defaults setObject:@"" forKey:@"token"];
        [defaults synchronize];
        [self.loginBtn setTitle:@"点击登录" forState:0];
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
