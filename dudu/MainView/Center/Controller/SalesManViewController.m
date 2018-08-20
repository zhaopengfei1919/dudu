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

- (void)viewDidLoad {
    [super viewDidLoad];
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
        
    };
}
- (IBAction)sure:(id)sender {
}

- (IBAction)cancel:(id)sender {
}
@end
