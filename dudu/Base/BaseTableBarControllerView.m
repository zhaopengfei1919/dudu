//
//  BaseTableBarControllerView.m
//  beautyLiveShow
//
//  Created by 枫 on 2017/7/3.
//  Copyright © 2017年 芦苇科技. All rights reserved.
//

#import "BaseTableBarControllerView.h"
#import "HomeViewController.h"

@interface BaseTableBarControllerView ()<UITabBarControllerDelegate>

@end

@implementation BaseTableBarControllerView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;//不透明
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
//    [self addChildVc:[[HomeViewController alloc] init] title:@"首页" image:@"btn_home_nom" selectedImage:@"btn_home_select"];
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (viewController.tabBarItem.tag == 3 || viewController.tabBarItem.tag == 4){
        if (viewController.tabBarItem.tag == 3) {
//            CKLoginVC *viewFlag = [[CKLoginVC alloc] init];
//            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:viewFlag];
//            [self presentViewController:navi animated:YES completion:^{
//            }];
            return NO;
        }else        {
            return YES;
        }
    } else    {
        return YES;
    }
}

@end

