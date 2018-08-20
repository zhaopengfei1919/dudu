//
//  BaseTableBarControllerView.m
//  beautyLiveShow
//
//  Created by 枫 on 2017/7/3.
//  Copyright © 2017年 芦苇科技. All rights reserved.
//

#import "BaseTableBarControllerView.h"
#import "HomeViewController.h"
#import "CategoryViewController.h"

@interface BaseTableBarControllerView ()<UITabBarControllerDelegate>

@end

@implementation BaseTableBarControllerView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;//不透明
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x9d9d9d), NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x20d994),NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
    NSArray * images = @[@"首页未选中",@"分类未选中",@"购物车未选中",@"个人中心未选中"];
    NSArray * imageselect = @[@"首页选中",@"分类选中",@"购物车选中",@"个人中心选中"];
    
    UITabBar *tabbar = self.tabBar;
    NSArray *items = tabbar.items;
    for (int i=0; i<4; i++) {
        UITabBarItem *item = items[i];

        item.image = [UIImage imageNamed:images[i]];
        item.selectedImage = [[UIImage imageNamed:imageselect[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (viewController == [tabBarController.viewControllers objectAtIndex:1]){
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"pushcategory" object:nil userInfo:nil]];
        return NO;
    } else    {
        return YES;
    }
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    // 判断本次点击的UITabBarItem是否和上次的一样
    
}

@end

