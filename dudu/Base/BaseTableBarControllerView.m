//
//  BaseTableBarControllerView.m
//  beautyLiveShow
//
//  Created by 枫 on 2017/7/3.
//  Copyright © 2017年 芦苇科技. All rights reserved.
//

#import "BaseTableBarControllerView.h"

@interface BaseTableBarControllerView ()<UITabBarControllerDelegate>

@end

@implementation BaseTableBarControllerView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;//不透明
}


@end

