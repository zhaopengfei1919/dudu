//
//  HomeHeader.m
//  dudu
//
//  Created by apple on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HomeHeader.h"
@interface HomeHeader()<SDCycleScrollViewDelegate>
@end

@implementation HomeHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setImageUrl:(NSArray *)imageUrl{
    _imageUrl = imageUrl;
    self.Scroll.imageURLStringsGroup = imageUrl;
    self.Scroll.delegate = self;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(homeScrollViewClickWith:)]) {
        [self.delegate homeScrollViewClickWith:index];
    }
}
@end
