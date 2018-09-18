//
//  TuiKuangTableViewCell.m
//  dudu
//
//  Created by apple on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TuiKuangTableViewCell.h"

@implementation TuiKuangTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.array = [[NSMutableArray alloc]init];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.OrderLabel.text = [NSString stringWithFormat:@"订单号：%@",[dic safeObjectForKey:@"orderId"]];
    self.dateLabel.text = [NSString stringWithFormat:@"下单时间：%@",[dic safeObjectForKey:@"orderDate"]];
    NSString * effectiveDate = [[NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"effectiveDate"]] substringToIndex:10];
    self.dateTimeLabel.text = [NSString stringWithFormat:@"%@即将过期",effectiveDate];
    
}

@end
