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
+ (void)initialize{
    UINavigationBar * navBar = [UINavigationBar appearance];
    [navBar setTintColor:BackGray_Color];
    navBar.barStyle = UIStatusBarStyleDefault ;
    //    [navBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:Title_Font size:18],NSForegroundColorAttributeName:Black_Color}];
    
    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Black_Color, NSForegroundColorAttributeName, [UIFont fontWithName:Title_Font size:18.0f],NSFontAttributeName,nil]];
    
    
    [navBar setBarTintColor:LightWhite_Color];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

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
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationController.navigationBar.hidden = NO;
        viewController.navigationController.navigationBar.backgroundColor = BackGray_Color;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIImageName(@"back") style:UIBarButtonItemStyleDone target:self action:@selector(backLastViewController)];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)backLastViewController {
    [MBProgressHUD hideActivityIndicator];
    [self popViewControllerAnimated:YES];
}

@end
