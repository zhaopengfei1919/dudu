//
//  HomeTableViewCell2.m
//  dudu
//
//  Created by apple on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HomeTableViewCell2.h"

@implementation HomeTableViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setArray:(NSArray *)array{
    HomeModel * model1 = array[0];
    HomeModel * model2 = array[1];
    
    [self.Image1 sd_setImageWithURL:[NSURL URLWithString:model1.image] placeholderImage:[UIImage imageNamed:@"logo拷贝"]];
    self.TitleLabel1.text = model1.name;
    if (model1.memo.length > 0) {
        self.ContentLabel1.text = model1.memo;
    }else
        self.ContentLabel1.text = @"";
    if (model1.tag.length > 0) {
        self.isCoupon1.hidden = NO;
        [self.isCoupon1 setTitle:model1.tag forState:0];
    }else
        self.isCoupon1.hidden = YES;
    
    self.unitPrice1.text = [NSString stringWithFormat:@"￥%.1f/%@",model1.unitPrice,model1.unit];
    
    NSString * str = [NSString stringWithFormat:@"总价￥%.1f",model1.price];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 3)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(3, string.length - 3)];
    self.PriceLabel1.attributedText = string;
    
    if (model1.packaging.length > 0) {
        self.GuigeLabel1.text = model1.packaging;
        self.GuigeLabel1.hidden = NO;
        self.GuigeLabel1.layer.cornerRadius = 3;
        self.GuigeLabel1.layer.borderWidth = 0.5;
        self.GuigeLabel1.layer.borderColor = UIColorFromRGB(0x20d994).CGColor;
        CGSize size = [[FYUser userInfo] sizeForString:model1.packaging withFontSize:10 withWidth:200];
        self.GuiGeLabelWidth1.constant = size.width + 8;
    }else
        self.GuigeLabel1.hidden = YES;
    
    if (model1.cartNumber > 0) {
        [self.CartBtn1 setBackgroundImage:[UIImage imageNamed:@""] forState:0];
    }else
        [self.CartBtn1 setBackgroundImage:[UIImage imageNamed:@"加入购物车"] forState:0];
    
    
    
    [self.image2 sd_setImageWithURL:[NSURL URLWithString:model2.image] placeholderImage:[UIImage imageNamed:@"logo拷贝"]];
    self.TitleLabel2.text = model2.name;
    if (model2.memo.length > 0) {
        self.ContentLabel2.text = model2.memo;
    }else
        self.ContentLabel2.text = @"";
    if (model2.tag.length > 0) {
        self.isCoupon2.hidden = NO;
        [self.isCoupon2 setTitle:model2.tag forState:0];
    }else
        self.isCoupon2.hidden = YES;
    
    self.unitPriceLabel2.text = [NSString stringWithFormat:@"￥%.1f/%@",model2.unitPrice,model2.unit];
    
    NSString * str1 = [NSString stringWithFormat:@"总价￥%.1f",model2.price];
    NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc]initWithString:str1];
    [string1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 3)];
    [string1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(3, string1.length - 3)];
    self.PriceLabel2.attributedText = string1;
    
    if (model2.packaging.length > 0) {
        self.GuigeLabel2.text = model2.packaging;
        self.GuigeLabel2.hidden = NO;
        self.GuigeLabel2.layer.cornerRadius = 3;
        self.GuigeLabel2.layer.borderWidth = 0.5;
        self.GuigeLabel2.layer.borderColor = UIColorFromRGB(0x20d994).CGColor;
        CGSize size = [[FYUser userInfo] sizeForString:model2.packaging withFontSize:10 withWidth:200];
        self.GuigeLabelWidth2.constant = size.width + 8;
    }else
        self.GuigeLabel2.hidden = YES;
    
    if (model2.cartNumber > 0) {
        [self.CartBtn2 setBackgroundImage:[UIImage imageNamed:@""] forState:0];
    }else
        [self.CartBtn2 setBackgroundImage:[UIImage imageNamed:@"加入购物车"] forState:0];
}
- (IBAction)gotodetail:(id)sender {
}

- (IBAction)addcart:(id)sender {
}
@end
