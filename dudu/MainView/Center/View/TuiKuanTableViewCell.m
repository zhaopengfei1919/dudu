//
//  TuiKuanTableViewCell.m
//  dudu
//
//  Created by apple on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TuiKuanTableViewCell.h"

@implementation TuiKuanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDic:(NSDictionary *)dic{
    self.orderLabel.text = [NSString stringWithFormat:@"订单号：%@",[dic safeObjectForKey:@"orderId"]];
    self.dateLabel.text = [NSString stringWithFormat:@"下单时间：%@",[dic safeObjectForKey:@"orderDate"]];
    
    for (UILabel * label in self.kuangScroll.subviews) {
        [label removeFromSuperview];
    }
    NSArray * array = [dic safeObjectForKey:@"boxs"];
    for (int i =0; i< array.count; i++) {
        NSDictionary * dic1 = array[i];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10 + 30*i, 80, 15)];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:15];
        label.text = [NSString stringWithFormat:@"%@",[dic1 safeObjectForKey:@"boxName"]];
        [self.kuangScroll addSubview:label];
        
        UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 10+30*i, 25, 15)];
        label1.textColor = UIColorFromRGB(0x666666);
        label1.font = [UIFont systemFontOfSize:14];
        label1.text = [NSString stringWithFormat:@"x%@",[dic1 safeObjectForKey:@"returnQty"]];
        [self.kuangScroll addSubview:label1];
        
        UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 75, 10, 60, 15)];
        label2.textAlignment = NSTextAlignmentRight;
        label2.textColor = UIColorFromRGB(0x333333);
        label2.font = [UIFont systemFontOfSize:15];
        float price = [[NSString stringWithFormat:@"%@",[dic1 safeObjectForKey:@"totalPrice"]] floatValue];
        label2.text = [NSString stringWithFormat:@"￥%.2f",price];
        [self.kuangScroll addSubview:label2];
    }
}
@end
