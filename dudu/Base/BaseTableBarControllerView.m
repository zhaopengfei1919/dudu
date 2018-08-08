//
//  BaseTableBarControllerView.m
//  beautyLiveShow
//
//  Created by 枫 on 2017/7/3.
//  Copyright © 2017年 芦苇科技. All rights reserved.
//

#import "BaseTableBarControllerView.h"
#import "STHomeViewController.h"
#import "STAttentionViewController.h"
#import "STCenterViewController.h"
#import "ConversationListViewController.h"
#import "NTESSessionListViewController.h"
#import "STSquareViewController.h"

@interface BaseTableBarControllerView ()<UITabBarControllerDelegate>

@end

@implementation BaseTableBarControllerView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [[UITabBar appearance] setBarTintColor:White_Color];
    [UITabBar appearance].translucent = NO;//不透明
    
    [self addChildVc:[[STHomeViewController alloc] init] title:@"视频聊天" image:@"btn_home_nom" selectedImage:@"btn_home_select"];
    
    [self addChildVc:[[STAttentionViewController alloc] init] title:@"关注" image:@"btn_follow_nom" selectedImage:@"btn_follow_select"];
    
//    if ([STUserModel sharedUserInfo].isOnline.intValue == 1) {
        [self addChildVc:[[STSquareViewController alloc] init] title:@"视频秀" image:@"btn_show_nom" selectedImage:@"btn_show_select"];
//    }

    [self addChildVc:[[NTESSessionListViewController alloc] init] title:@"消息" image:@"btn_message_nom" selectedImage:@"btn_message_select"];
    
    [self addChildVc:[[STCenterViewController alloc] init] title:@"个人中心" image:@"btn_user_nom" selectedImage:@"btn_user_select"];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
    childVc.title = title;
    // 设置子控制器的tabBarItem图片
    //UIImageRenderingModeAlwaysOriginal  去掉默认的灰色渲染
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 禁用图片渲染
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置文字样式
    [childVc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontGray_Color, NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:BlackFont_Color, NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    
    BaseNavigationController * navigationVc = [[BaseNavigationController alloc] initWithRootViewController:childVc];
    
    // 添加子控制器
    [self addChildViewController:navigationVc];
}


// 返回 YES 执行跳转，返回 NO 不执行跳转
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([STUserModel sharedUserInfo].token.length < 8 && viewController != [tabBarController.viewControllers objectAtIndex:2]) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:NotokenNotification object:nil userInfo:nil]];
        return NO;
    }
    return YES;
}


@end

