//
//  BaseNavigationController.m
//  beautyLiveShow
//
//  Created by 枫 on 2017/7/3.
//  Copyright © 2017年 芦苇科技. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// 只初始化一次

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIViewController *topvc = self.topViewController;
    return [topvc preferredStatusBarStyle];
}

/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if (self.viewControllers.count > 0) {
//        viewController.hidesBottomBarWhenPushed = YES;
//        viewController.navigationController.navigationBar.hidden = NO;
//        viewController.navigationController.navigationBar.backgroundColor = BackGray_Color;
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIImageName(@"back") style:UIBarButtonItemStyleDone target:self action:@selector(backLastViewController)];
//    }
    [super pushViewController:viewController animated:animated];
}

- (void)backLastViewController {
    [self popViewControllerAnimated:YES];
}

@end
