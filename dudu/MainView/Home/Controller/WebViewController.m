//
//  WebViewController.m
//  dudu
//
//  Created by apple on 2018/9/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.web = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - StatusHeight - BarBottomHeight)];
    NSURL * url = [NSURL URLWithString:self.HtmlUrl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.web loadRequest:request];
    [self.view addSubview:self.web];
    
    self.title = self.Titlestr;
    
    if (![self.navigationController visibleViewController]) {
        [self.view addSubview:self.navView];
        self.web.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - StatusHeight - BarBottomHeight - 64);
    }
    
    // Do any additional setup after loading the view.
}
- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44 + StatusHeight)];
        _navView.backgroundColor = [UIColor whiteColor];
        // 返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(10, StatusHeight + 9, 50, 22);
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 28);
        
        [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImage:[UIImage imageNamed:@"返回"] forState:0];
        [_navView addSubview:backButton];
        // 标题
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(100, StatusHeight + 10, SCREEN_WIDTH - 200, 20)];
        label.text = self.Titlestr;
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        [_navView addSubview:label];
    }
    return _navView;
}
// 点击返回按钮
- (void)backButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
