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
-(void)setGoodsData:(NSDictionary *)GoodsData{
    _GoodsData = GoodsData;
    
    NSDate *second = [NSDate date];
    long secondTimeZone = [second timeIntervalSince1970];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *lastTime = [GoodsData safeObjectForKey:@"endDate"];
    NSDate *lastDate = [formatter dateFromString:lastTime];
    //以 1970/01/01 GMT为基准，得到lastDate的时间戳
    long firstStamp = [lastDate timeIntervalSince1970];
    
    long time = firstStamp - secondTimeZone;
    int hour = (int)time/(3600*24)/3600;
    self.Hour.text = [NSString stringWithFormat:@"%.2d",hour];
    
    int minute = (int)time%3600/60;
    self.Minute.text = [NSString stringWithFormat:@"%.2d",minute];
    
    int seco = (int)time%3600%60;
    self.Second.text = [NSString stringWithFormat:@"%.2d",seco];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daoshu) userInfo:nil repeats:YES];
    
}
- (void)daoshu{
    NSDate *second = [NSDate date];
    long secondTimeZone = [second timeIntervalSince1970];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *lastTime = [self.GoodsData safeObjectForKey:@"endDate"];
    NSDate *lastDate = [formatter dateFromString:lastTime];
    //以 1970/01/01 GMT为基准，得到lastDate的时间戳
    long firstStamp = [lastDate timeIntervalSince1970];
    
    long time = firstStamp - secondTimeZone;
    int hour = (int)time/(3600*24)/3600;
    self.Hour.text = [NSString stringWithFormat:@"%.2d",hour];
    
    int minute = (int)time%3600/60;
    self.Minute.text = [NSString stringWithFormat:@"%.2d",minute];
    
    int seco = (int)time%3600%60;
    self.Second.text = [NSString stringWithFormat:@"%.2d",seco];
    
    NSArray * productInfoList = [_GoodsData safeObjectForKey:@"productInfoList"];
    HomeModel * data1 = [HomeModel mj_objectWithKeyValues:productInfoList[0]];
    HomeModel * data2 = [HomeModel mj_objectWithKeyValues:productInfoList[1]];
    HomeModel * data3 = [HomeModel mj_objectWithKeyValues:productInfoList[2]];
    
    [self.Image1 sd_setImageWithURL:[NSURL URLWithString:data1.image] placeholderImage:[UIImage imageNamed:@"logo拷贝"]];
    self.Price1.text = [NSString stringWithFormat:@"￥%.1f",data1.price];
    NSString * str1 = [NSString stringWithFormat:@"￥%.1f",data1.unitPrice];
    NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc]initWithString:str1];
    [string1 addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, str1.length)];
    self.CostPrice1.attributedText = string1;
    
    [self.image2 sd_setImageWithURL:[NSURL URLWithString:data2.image] placeholderImage:[UIImage imageNamed:@"logo拷贝"]];
    self.Price2.text = [NSString stringWithFormat:@"￥%.1f",data2.price];
    NSString * str2 = [NSString stringWithFormat:@"￥%.1f",data2.unitPrice];
    NSMutableAttributedString * string2 = [[NSMutableAttributedString alloc]initWithString:str2];
    [string2 addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, str2.length)];
    self.CostPrice2.attributedText = string2;
    
    [self.Image3 sd_setImageWithURL:[NSURL URLWithString:data3.image] placeholderImage:[UIImage imageNamed:@"logo拷贝"]];
    self.Price3.text = [NSString stringWithFormat:@"￥%.1f",data3.price];
    NSString * str3 = [NSString stringWithFormat:@"￥%.1f",data3.unitPrice];
    NSMutableAttributedString * string3 = [[NSMutableAttributedString alloc]initWithString:str3];
    [string3 addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, str3.length)];
    self.CostPrice3.attributedText = string3;
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(homeScrollViewClickWith:)]) {
        [self.delegate homeScrollViewClickWith:index];
    }
}
- (IBAction)btntoDeatail:(id)sender {
}
@end
