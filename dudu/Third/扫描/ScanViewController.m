//
//  ScanViewController.m
//  CSHScanDemo
//
//  Created by hh on 15/12/24.
//  Copyright © 2015年 陈胜辉. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRScanHeader.h"
#import "QRView.h"

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,QRViewDelegate,UIAlertViewDelegate>{
    NSString *stringValue;
}

@property (strong, nonatomic) AVCaptureDevice * device;
@property (strong, nonatomic) AVCaptureDeviceInput * input;
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
//扫描框
@property (strong, nonatomic) AVCaptureSession * session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;

@property (strong,nonatomic) UIButton * lightBtn;
@property (strong,nonatomic) UILabel * tishiLabel;

@end

@implementation ScanViewController
- (void)backLastViewController {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 11 + StatusHeight, 50, 22);
    
    [backButton addTarget:self action:@selector(backLastViewController) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"返回"] forState:0];
    [self.view addSubview:backButton];
   
    // Do any additional setup after loading the view.
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    //_output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    //增加条形码扫描
    _output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
                                    AVMetadataObjectTypeEAN8Code,
                                    AVMetadataObjectTypeCode128Code,
                                    AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity =AVLayerVideoGravityResize;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    
    
    UIScrollView * scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT+20)];
    [self.view addSubview:scroll];
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    QRView *qrRectView = [[QRView alloc] initWithFrame:screenRect];
    qrRectView.transparentArea = CGSizeMake(SCREEN_WIDTH - 150, SCREEN_WIDTH - 150);
    qrRectView.backgroundColor = [UIColor clearColor];
    qrRectView.center = self.view.center;
    qrRectView.delegate = self;
    [scroll addSubview:qrRectView];
    
    //修正扫描区域
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    CGRect cropRect = CGRectMake((screenWidth - qrRectView.transparentArea.width) / 2,ScanView_Y,qrRectView.transparentArea.width,qrRectView.transparentArea.height);

    [_output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,cropRect.origin.x / screenWidth,cropRect.size.height / screenHeight,cropRect.size.width / screenWidth)];
    //提示文字
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(10, ScanView_Y - 80, screenWidth - 20, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.text=@"将二维码/条形码放在取景框中，即可自动扫描";
    [qrRectView addSubview:labIntroudction];
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(2, 28, 50, 28);
    [button setImage:[UIImage imageNamed:@"back_white"] forState:0];
    [button addTarget:self action:@selector(backtoRoot) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2 - 50, 32, 100, 20)];
    label.text = @"扫一扫";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:label];
    
    _lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lightBtn.frame = CGRectMake(screenWidth/2 - 20, ScanView_Y + cropRect.size.height + 60, 40, 40);
    [_lightBtn setImage:[UIImage imageNamed:@"sm_on"] forState:0];
    [_lightBtn addTarget:self action:@selector(openlight) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:_lightBtn];
    
    _tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 100, ScanView_Y + cropRect.size.height + 110, 200, 20)];
    _tishiLabel.text = @"闪光灯";
    _tishiLabel.textColor = [UIColor whiteColor];
    _tishiLabel.textAlignment = NSTextAlignmentCenter;
    _tishiLabel.font = [UIFont systemFontOfSize:15];
    [scroll addSubview:_tishiLabel];

    scroll.contentSize = CGSizeMake(screenWidth, ScanView_Y + cropRect.size.height + 200);
}
-(void)openlight{
    static BOOL isopen = YES;

    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) { // 判断是否有闪光灯
            // 请求独占访问硬件设备
            [device lockForConfiguration:nil];
            if (isopen) {
                [_lightBtn setImage:[UIImage imageNamed:@"sm_off"] forState:0];
                _tishiLabel.text = @"关闭闪光灯";
                [device setTorchMode:AVCaptureTorchModeOn]; // 手电筒开
            }else{
                [_lightBtn setImage:[UIImage imageNamed:@"sm_on"] forState:0];
                _tishiLabel.text = @"闪光灯";
                [device setTorchMode:AVCaptureTorchModeOff]; // 手电筒关
            }
            // 请求解除独占访问硬件设备
            [device unlockForConfiguration];
        }
    }
    isopen = !isopen;
    
    
}
-(void)backtoRoot{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [_session startRunning];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //[self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
}

#pragma mark QRViewDelegate
//下方点击切换类型
-(void)scanTypeConfig:(QRItem *)item {
    
    if (item.type == QRItemTypeQRCode) {
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
        
    } else if (item.type == QRItemTypeOther) {
        _output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
                                        AVMetadataObjectTypeEAN8Code,
                                        AVMetadataObjectTypeCode128Code,
                                        AVMetadataObjectTypeQRCode];
    }
}
//扫描完成操作
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([metadataObjects count] >0)
    {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) { // 判断是否有闪光灯
            // 请求独占访问硬件设备
            [device lockForConfiguration:nil];
            [device setTorchMode:AVCaptureTorchModeOff]; // 手电筒关
            // 请求解除独占访问硬件设备
            [device unlockForConfiguration];
        }
        [_session stopRunning];
    
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    NSLog(@" 结果：%@",stringValue);
    
    if (self.qrUrlBlock) {
        self.qrUrlBlock(stringValue);
        [self.navigationController popViewControllerAnimated:NO];
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

@end
