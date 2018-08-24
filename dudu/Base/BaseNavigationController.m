//
//  BaseNavigationController.m
//  beautyLiveShow
//
//  Created by 枫 on 2017/7/3.
//  Copyright © 2017年 芦苇科技. All rights reserved.
//

#import "BaseNavigationController.h"
#import "CategoryViewController.h"

@interface BaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate =  self;
    
    self.navigationBar.translucent =NO;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];

    [self.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      UIColorFromRGB(0x333333),NSForegroundColorAttributeName,
      [UIFont systemFontOfSize:18], NSFontAttributeName,
      nil]];
    

    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushcategory" object:nil];
    [super viewWillDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpTocategoryController) name:@"pushcategory" object:nil];
}
- (void)jumpTocategoryController{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CategoryViewController * category = [sb instantiateViewControllerWithIdentifier:@"CategoryViewController"];
    [self pushViewController:category animated:YES];
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
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 50, 22);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 28);
    
    [backButton addTarget:self action:@selector(backLastViewController) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"返回"] forState:0];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    viewController.navigationItem.leftBarButtonItem = backItem;
    viewController.title = viewController.title;
    
}

- (void)backLastViewController {
    [self popViewControllerAnimated:YES];
}

@end
