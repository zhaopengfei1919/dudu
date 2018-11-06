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
    _model = model;
    [self.Image sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"logo拷贝"]];
    self.TitleLabel.text = model.name;
    if (model.memo.length > 0) {
        self.ConteneLabel.text = model.memo;
    }else
        self.ConteneLabel.text = @"";
    if (model.tag.length > 0) {
        [self.CouponImage sd_setImageWithURL:[NSURL URLWithString:model.tag]];
        self.CouponImage.hidden = NO;
    }else
        self.CouponImage.hidden = YES;
        
//    self.unitPriceLabel.text = [NSString stringWithFormat:@"￥%.2f/%@",model.unitPrice,model.unit];
    
    NSString * str = [NSString stringWithFormat:@"总价￥%.2f",model.price];
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
    }else{
        self.GuigeLabelWidth.constant = 0;
        self.GuiGeLabel.hidden = YES;
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
    
    if (model.cartNumber > 0) {
        [self.CartBtn setBackgroundImage:[UIImage imageNamed:@"加入购物车"] forState:0];
    }else
        [self.CartBtn setBackgroundImage:[UIImage imageNamed:@"加入购物车"] forState:0];
}
-(void)login{
    id object = [self nextResponder];
    while (![object isKindOfClass:[UIViewController class]] && object != nil) {
        object = [object nextResponder];
    }
    UIViewController *superController = (UIViewController*)object;
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController * login = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [superController presentViewController:login animated:YES completion:^{
        
    }];
}
- (IBAction)addcart:(id)sender {
    if ([FYUser userInfo].token.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        [self login];
        return;
    }
    if (self.model.specificationNumber == 0) {//没有规格，直接加入购物车
        NSMutableDictionary *paraDic = @{}.mutableCopy;
        [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"quantity"];
        NSMutableDictionary * dic = @{}.mutableCopy;
        [dic setObject:self.model.ID forKey:@"id"];
        [paraDic setObject:dic forKey:@"productParam"];
        
        [self sureaddcart:paraDic];
    }else{//多规格，调用商品详情接口，获取规格信息
        //        WS(weakself);
        NSMutableDictionary *paraDic = @{}.mutableCopy;
        [paraDic setObject:self.model.ID forKey:@"id"];
        [NetWorkManager requestWithMethod:POST Url:GoodsDetail Parameters:paraDic success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            NSString * code = [responseObject safeObjectForKey:@"code"];
            if ([code isEqualToString:@"0"]) {
                UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
                self->submitView = [[[NSBundle mainBundle] loadNibNamed:@"HZSubmitView" owner:self options:nil] objectAtIndex:0];
                self->submitView.frame = window.bounds;
                [self->submitView createViewWith:[responseObject safeObjectForKey:@"data"]];
                [self->submitView createBigviewWith:[responseObject safeObjectForKey:@"data"]];
                [self->submitView.SureBtn addTarget:self action:@selector(cartadd) forControlEvents:UIControlEventTouchUpInside];
                [window addSubview:self->submitView];
            }else
                [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
        } requestRrror:^(id requestRrror) {
            
        }];
    }
}
-(void)cartadd{
    NSArray * specifications = [submitView.data safeObjectForKey:@"specifications"];
    if (specifications.count == 2) {
        if (submitView.firstID.length == 0 || submitView.secondID.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请选择相应规格"];
            return;
        }
    }else if (specifications.count == 1){
        if (submitView.firstID.length == 0){
            [SVProgressHUD showErrorWithStatus:@"请选择相应规格"];
            return;
        }
    }
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:submitView.CountLabel.text forKey:@"quantity"];
    NSMutableDictionary * dic = @{}.mutableCopy;
    [dic setObject:submitView.GoodsID forKey:@"id"];
    [paraDic setObject:dic forKey:@"productParam"];
    
    [self sureaddcart:paraDic];
}
-(void)sureaddcart:(NSDictionary *)dic{
    [NetWorkManager requestWithMethod:POST Url:CartAdd Parameters:dic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"加入购物车成功"];
            [self->submitView removeFromSuperview];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
@end
