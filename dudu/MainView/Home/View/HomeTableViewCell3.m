//
//  HomeTableViewCell3.m
//  dudu
//
//  Created by apple on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HomeTableViewCell3.h"
#import "PromotionViewController.h"

@implementation HomeTableViewCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    self.image1.layer.cornerRadius = 5;
    self.image2.layer.cornerRadius = 5;
    self.image3.layer.cornerRadius = 5;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setArray:(NSArray *)array{
    _array = array;
    PromotionModel * model1 = array[0];
    PromotionModel * model2 = array[1];
    PromotionModel * model3 = array[2];
    
    [self.image1 sd_setImageWithURL:[NSURL URLWithString:model1.mobileImage]];
    [self.image2 sd_setImageWithURL:[NSURL URLWithString:model2.mobileImage]];
    [self.image3 sd_setImageWithURL:[NSURL URLWithString:model3.mobileImage]];
    
    self.btn1.tag = 0;
    self.btn2.tag = 1;
    self.btn3.tag = 2;
    
    [self.btn1 addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn2 addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn3 addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)btnclick:(UIButton *)btn{
    id object = [self nextResponder];
    while (![object isKindOfClass:[UIViewController class]] && object != nil) {
        object = [object nextResponder];
    }
    UIViewController *superController = (UIViewController*)object;
    
    PromotionModel * model1 = self.array[btn.tag];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PromotionViewController * promotion = [sb instantiateViewControllerWithIdentifier:@"PromotionViewController"];
    promotion.ID = model1.ID;
    promotion.imageurl = model1.mobileImage;
    [superController.navigationController pushViewController:promotion animated:YES];
}
@end
