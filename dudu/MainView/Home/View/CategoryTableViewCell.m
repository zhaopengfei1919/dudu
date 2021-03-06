//
//  CategoryTableViewCell.m
//  dudu
//
//  Created by apple on 2018/8/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CategoryTableViewCell.h"

@implementation CategoryTableViewCell

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
        self.GuiGeLabelWidth.constant = size.width + 8;
    }else{
        self.GuiGeLabelWidth.constant = 0;
        self.GuigeLabel.hidden = YES;
    }
    
    if (model.weight > 0) {
        self.weightLabel.text = [NSString stringWithFormat:@"约%.1f斤",model.weight];
        self.weightLabel.hidden = NO;
        self.weightLabel.layer.cornerRadius = 3;
        self.weightLabel.layer.borderWidth = 0.5;
        self.weightLabel.layer.borderColor = UIColorFromRGB(0x20d994).CGColor;
        CGSize size = [[FYUser userInfo] sizeForString:self.weightLabel.text withFontSize:10 withWidth:200];
        self.weightLabelWidth.constant = size.width + 8;
    }else
        self.weightLabel.hidden = YES;
    
}
@end
