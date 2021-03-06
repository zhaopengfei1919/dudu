//
//  ShopCartTableViewCell.m
//  dudu
//
//  Created by apple on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShopCartTableViewCell.h"

@implementation ShopCartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(HomeModel *)model{
    [self.MainImage sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"logo拷贝"]];
    self.titleLabel.text = model.name;

    self.unitPriceLabel.text = [NSString stringWithFormat:@"￥%.2f/%@",model.unitPrice,model.unit];
    
    NSString * str = [NSString stringWithFormat:@"总价￥%.2f",model.price];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 3)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(3, string.length - 3)];
    self.PriceLabel.attributedText = string;
    
    if (model.packaging.length > 0) {
        self.GuigeLabel.text = model.packaging;
        self.GuigeLabel.hidden = NO;
        self.GuigeLabel.layer.cornerRadius = 3;
        self.GuigeLabel.layer.borderWidth = 0.5;
        self.GuigeLabel.layer.borderColor = UIColorFromRGB(0x20d994).CGColor;
        CGSize size = [[FYUser userInfo] sizeForString:model.packaging withFontSize:10 withWidth:200];
        self.GuigeLabelWidth.constant = size.width + 8;
    }else{
        self.GuigeLabelWidth.constant = 0;
        self.GuigeLabel.hidden = YES;
    }
    
    self.signLabel.layer.borderWidth = 0.5;
    self.signLabel.layer.borderColor = UIColorFromRGB(0xf39700).CGColor;
    self.signLabel.layer.cornerRadius = 2;
}

@end
