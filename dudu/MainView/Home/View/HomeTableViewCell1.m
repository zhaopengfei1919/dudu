//
//  HomeTableViewCell1.m
//  dudu
//
//  Created by apple on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HomeTableViewCell1.h"

@implementation HomeTableViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(HomeModel *)model{
    [self.Image sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"logo拷贝"]];
    self.TitleLabel.text = model.name;
    if (model.memo.length > 0) {
        self.ConteneLabel.text = model.memo;
    }else
        self.ConteneLabel.text = @"";
    if (model.tag.length > 0) {
        self.IsCoupon.hidden = NO;
        [self.IsCoupon setTitle:model.tag forState:0];
    }else
        self.IsCoupon.hidden = YES;
    
    self.unitPriceLabel.text = [NSString stringWithFormat:@"￥%.1f/%@",model.unitPrice,model.unit];
    
    NSString * str = [NSString stringWithFormat:@"总价￥%.1f",model.price];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 3)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(3, string.length - 3)];
    self.PriceLabel.attributedText = string;
    
    if (model.packaging.length > 0) {
        self.GuiGeLabel.text = model.packaging;
        self.GuiGeLabel.hidden = NO;
        self.GuiGeLabel.layer.cornerRadius = 3;
        self.GuiGeLabel.layer.borderWidth = 0.5;
        self.GuiGeLabel.layer.borderColor = UIColorFromRGB(0x20d994).CGColor;
        CGSize size = [[FYUser userInfo] sizeForString:model.packaging withFontSize:10 withWidth:200];
        self.GuigeLabelWidth.constant = size.width + 8;
    }else
        self.GuiGeLabel.hidden = YES;
    
    if (model.cartNumber > 0) {
        [self.CartBtn setBackgroundImage:[UIImage imageNamed:@""] forState:0];
    }else
        [self.CartBtn setBackgroundImage:[UIImage imageNamed:@"加入购物车"] forState:0];
}
@end
