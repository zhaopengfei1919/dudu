//
//  SalesManViewController.m
//  dudu
//
//  Created by apple on 2018/8/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SalesManViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanViewController.h"

@interface SalesManViewController ()

@end

@implementation SalesManViewController
-(void)mysalesman{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    
    [NetWorkManager requestWithMethod:POST Url:MyCoupon Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        NSDictionary * data = [responseObject safeObjectForKey:@"data"];
        if ([code isEqualToString:@"0"] && data.count > 0) {
            weakself.dic = data;
            weakself.SalesmanLabel.text = [NSString stringWithFormat:@"%@  %@",[data safeObjectForKey:@"name"],[data safeObjectForKey:@"code"]];
        }
    } requestRrror:^(id requestRrror) {
        
    }];
}
-(void)bingsalesman{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:self.salesLabel.text forKey:@"id"];
    
    [NetWorkManager requestWithMethod:POST Url:BingSalesMan Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            [weakself.navigationController popViewControllerAnimated:YES];
        }
    } requestRrror:^(id requestRrror) {
        
    }];
}
-(void)cancelsalesman{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    
    [NetWorkManager requestWithMethod:POST Url:CancelSalesMan Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            [weakself.navigationController popViewControllerAnimated:YES];
        }
    } requestRrror:^(id requestRrror) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self mysalesman];
    
    self.sureBtn.layer.cornerRadius = 3;
    self.cancelBtn.layer.cornerRadius = 3;
    self.cancelBtn.layer.borderWidth = 0.5;
    self.cancelBtn.layer.borderColor = UIColorFromRGB(0x20d994).CGColor;
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

- (IBAction)edit:(id)sender {
    self.View2.hidden = NO;
    if (self.dic.count > 0) {
        self.salesLabel.text = [NSString stringWithFormat:@"%@  %@",[self.dic safeObjectForKey:@"name"],[self.dic safeObjectForKey:@"code"]];
        self.cancelBtn.hidden = NO;
    }else{
        self.salesLabel.text = @"扫描业务员条码";
        self.cancelBtn.hidden = YES;
    }
}
- (IBAction)saomiao:(id)sender {
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSString *errorStr = @"应用相机权限受限,请在设置中启用";
        [SVProgressHUD showErrorWithStatus:errorStr];
        return;
    }
    ScanViewController * scan = [[ScanViewController alloc]init];
    [self.navigationController pushViewController:scan animated:YES];
    scan.qrUrlBlock = ^(NSString *str){
        self.salesLabel.text = str;
    };
}
- (IBAction)sure:(id)sender {
    if ([self.salesLabel.text isEqualToString:@"扫描业务员条码"]) {
        [SVProgressHUD showErrorWithStatus:@"请扫描业务员条码"];
        return;
    }
    [self bingsalesman];
}

- (IBAction)cancel:(id)sender {
    [self cancelsalesman];
}
@end
