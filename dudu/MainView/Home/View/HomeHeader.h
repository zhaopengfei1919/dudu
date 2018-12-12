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



@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *Hour;
@property (weak, nonatomic) IBOutlet UILabel *Minute;
@property (weak, nonatomic) IBOutlet UILabel *Second;

@property (weak, nonatomic) IBOutlet UIImageView *Image1;
@property (weak, nonatomic) IBOutlet UILabel *Price1;
@property (weak, nonatomic) IBOutlet UILabel *CostPrice1;

- (IBAction)btntoDeatail:(id)sender;


@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UILabel *Price2;
@property (weak, nonatomic) IBOutlet UILabel *CostPrice2;

@property (weak, nonatomic) IBOutlet UIImageView *Image3;
@property (weak, nonatomic) IBOutlet UILabel *Price3;
@property (weak, nonatomic) IBOutlet UILabel *CostPrice3;

@property (strong,nonatomic) NSDictionary * GoodsData;

@property (nonatomic, strong) NSTimer *timer;
@end
