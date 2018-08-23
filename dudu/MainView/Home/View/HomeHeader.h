//
//  HomeHeader.h
//  dudu
//
//  Created by apple on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol homeHeaderViewDelegate <NSObject>

/** 点击滚动视图的图片代理方法 */
- (void)homeScrollViewClickWith:(NSInteger)index;
@end

@interface HomeHeader : UIView

@property (weak,nonatomic) id<homeHeaderViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *Scroll;

/** 图片链接 */
@property (nonatomic, strong) NSArray * imageUrl;
@end
