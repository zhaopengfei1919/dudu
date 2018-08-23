//
//  UITabBar+badge.m
//  DLWebsite
//
//  Created by Apple　 on 16/6/30.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "UITabBar+badge.h"
#define TabbarItemNums 4.0    //tabbar的数量 如果是5个设置为5.0

@implementation UITabBar (badge)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)showBadgeOnItemIndex:(int)index Withnum:(int)num{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 8;//圆形
    badgeView.backgroundColor = UIColorFromRGB(0x20d994);
    CGRect tabFrame = self.frame;
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = UIColorFromRGB(0xffffff);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%d",num];
    [badgeView addSubview:label];
    
    //确定小红点的位置
    float percentX = (index +0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x-5, y-2, 16, 16);//圆形大小为10
    [self addSubview:badgeView];
}
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}
@end
