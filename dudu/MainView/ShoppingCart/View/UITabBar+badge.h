//
//  UITabBar+badge.h
//  DLWebsite
//
//  Created by Apple　 on 16/6/30.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)
- (void)showBadgeOnItemIndex:(int)index Withnum:(int)num;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点
@end
