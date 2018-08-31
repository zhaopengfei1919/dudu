//
//  CouponTableViewCell.m
//  dudu
//
//  Created by apple on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CouponTableViewCell.h"

@implementation CouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btn.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 1;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(CouponModel *)model{
    NSString * str1 = [NSString stringWithFormat:@"￥%lu",model.amount];
    NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc]initWithString:str1];
    [string1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, 1)];
    [string1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:44] range:NSMakeRange(1, string1.length - 1)];
    self.moneyLabel.attributedText = string1;
    
//    self.moneyLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.amount];
    if (![model.anHaoType isEqualToString:@"ALL_SHOP"]) {//代金券
        self.descLabel.text = @"代金券";
        self.titleLabel.text = [NSString stringWithFormat:@"%lu元代金券",model.amount];
    }else{//全场满减
        self.descLabel.text = [NSString stringWithFormat:@"满%lu元可用",model.lowLimit];
        self.titleLabel.text = [NSString stringWithFormat:@"满%lu元减%lu",model.lowLimit,model.amount];
    }
    
    self.DateLabel.text = [NSString stringWithFormat:@"%@ - %@",model.startDate,model.endDate];
    
    if ([model.anHaoStatus isEqualToString:@"NEW"]) {
        self.backImage.image = [UIImage imageNamed:@"未使用优惠券"];
        [self.btn setTitle:@"立即使用" forState:0];
        [self.btn setTitleColor:UIColorFromRGB(0x20d994) forState:0];
        self.btn.layer.borderColor = UIColorFromRGB(0x20d994).CGColor;
        self.btn.enabled = YES;
    }else if ([model.anHaoStatus isEqualToString:@"USERD"]) {
        self.backImage.image = [UIImage imageNamed:@"已过期优惠券"];
        [self.btn setTitle:@"已使用" forState:0];
        [self.btn setTitleColor:UIColorFromRGB(0xcccccc) forState:0];
        self.btn.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
        self.btn.enabled = NO;
    }else{
        self.backImage.image = [UIImage imageNamed:@"已过期优惠券"];
        [self.btn setTitle:@"已过期" forState:0];
        [self.btn setTitleColor:UIColorFromRGB(0xcccccc) forState:0];
        self.btn.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
        self.btn.enabled = NO;
    }
}
@end
