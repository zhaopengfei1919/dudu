//
//  AddressEditViewController.m
//  dudu
//
//  Created by apple on 2018/8/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AddressEditViewController.h"
#import "HZCityViewController.h"

@interface AddressEditViewController ()

@end

@implementation AddressEditViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.area.length > 0) {
        self.AddressLabel.text = [NSString stringWithFormat:@"上海市 %@",self.area];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isedit) {
        self.title = @"编辑地址";
        self.NameTF.text = self.model.consignee;
        self.PhoneTF.text = self.model.phone;
        self.AreaTF.text = self.model.address;
        NSDictionary * areaInfo = self.model.areaInfo;
        self.areaid = [areaInfo safeObjectForKey:@"id"];
        self.area = [areaInfo safeObjectForKey:@"name"];
        
        self.deleteBtn.hidden = NO;
        self.deleteBtn.layer.cornerRadius = 3;
        self.deleteBtn.layer.borderWidth = 0.5;
        self.deleteBtn.layer.borderColor = UIColorFromRGB(0x20d994).CGColor;
    }else{
        self.title = @"新增地址";
    }
    
    self.SureBtn.layer.cornerRadius = 3;
    // Do any additional setup after loading the view.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.NameTF resignFirstResponder];
    [self.PhoneTF resignFirstResponder];
    [self.AreaTF resignFirstResponder];
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

- (IBAction)chosenaddress:(id)sender {
    HZCityViewController * city = [[HZCityViewController alloc]init];
    [self.navigationController pushViewController:city animated:YES];
}
- (IBAction)Sure:(id)sender {
    if (self.NameTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入联系人姓名"];
        return;
    }
    if (![[FYUser userInfo] isphonenumberwoth:self.PhoneTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    if ([self.AddressLabel.text isEqualToString:@"请选择"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择区域"];
        return;
    }
    if (self.AreaTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入详细地址"];
        return;
    }
    WS(weakself);
    
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    NSString * urlStr = Addaddress;
    if (self.isedit) {
        [paraDic setObject:self.model.ID forKey:@"id"];
        urlStr = UpdetaAddress;
    }
    [paraDic setObject:self.NameTF.text forKey:@"consignee"];
    [paraDic setObject:self.PhoneTF.text forKey:@"phone"];
    [paraDic setObject:[NSNumber numberWithInt:792] forKey:@"province"];
    [paraDic setObject:self.AreaTF.text forKey:@"address"];
    [paraDic setObject:[NSNumber numberWithBool:YES] forKey:@"default"];
    [paraDic setObject:@{@"id":self.areaid} forKey:@"areaParam"];
    
    [NetWorkManager requestWithMethod:POST Url:urlStr Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject objectForKey:@"code"];
        if ([code intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@成功",self.title]];
            [weakself.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"errmsg"]];
        }
    } requestRrror:^(id requestRrror) {
        
    }];
}
- (IBAction)deleteaddress:(id)sender {
    WS(weakself);
    
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:self.model.ID forKey:@"id"];
    
    [NetWorkManager requestWithMethod:POST Url:DeleteAddress Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject objectForKey:@"code"];
        if ([code intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [weakself.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"errmsg"]];
        }
    } requestRrror:^(id requestRrror) {
        
    }];
}
@end
