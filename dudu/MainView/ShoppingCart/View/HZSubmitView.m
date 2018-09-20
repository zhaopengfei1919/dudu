//
//  HZSubmitView.m
//  DLWebsite
//
//  Created by Apple　 on 16/11/10.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "HZSubmitView.h"

@implementation HZSubmitView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapview:)];
    [self.backView addGestureRecognizer:tap];
}
-(void)tapview:(UITapGestureRecognizer *)tap{
    [self remove:nil];
}

- (IBAction)remove:(id)sender {
    [self removeFromSuperview];
}
-(void)createViewWith:(NSDictionary *)MyData{
    self.GoodsID = [MyData safeObjectForKey:@"id"];
    self.data = MyData;
    
    self.PriceLabel.text = [NSString stringWithFormat:@"%@",[MyData safeObjectForKey:@"itemPrice"]];
    [self.MainImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[MyData safeObjectForKey:@"image"]]]];

    self.MainLabel.text = [MyData safeObjectForKey:@"name"];
    
    self.Jia.userInteractionEnabled = YES;
    self.Jian.userInteractionEnabled = YES;
    [self.Jian addTarget:self action:@selector(jian:) forControlEvents:UIControlEventTouchUpInside];
    [self.Jia addTarget:self action:@selector(jia:) forControlEvents:UIControlEventTouchUpInside];
    
    float unitPrice = [[MyData safeObjectForKey:@"unitPrice"] floatValue];
    self.unitPriceLabel.text = [NSString stringWithFormat:@"￥%.2f/%@",unitPrice,[MyData safeObjectForKey:@"unit"]];
    
    float price = [[MyData safeObjectForKey:@"price"] floatValue];
    NSString * str = [NSString stringWithFormat:@"总价￥%.2f",price];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 3)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(3, string.length - 3)];
    self.PriceLabel.attributedText = string;
    
    NSString * packaging = [MyData safeObjectForKey:@"packaging"];
    if (packaging.length > 0) {
        self.GuigeLabel.text = packaging;
        self.GuigeLabel.hidden = NO;
        self.GuigeLabel.layer.cornerRadius = 3;
        self.GuigeLabel.layer.borderWidth = 0.5;
        self.GuigeLabel.layer.borderColor = UIColorFromRGB(0x20d994).CGColor;
        CGSize size = [[FYUser userInfo] sizeForString:packaging withFontSize:10 withWidth:200];
        self.GuigeLabelWidth.constant = size.width + 8;
    }else
        self.GuigeLabel.hidden = YES;
}
-(void)createBigviewWith:(NSDictionary *)data{
    NSArray * specifications = [data safeObjectForKey:@"specifications"];
    float height = 0;
    for (UIView *vi in self.ColorView.subviews) {
        if ([vi isKindOfClass:[DDButton class]] || [vi isKindOfClass:[UILabel class]]) {
            [vi removeFromSuperview];
        }
    }
    float buttonwidth = (SCREEN_WIDTH - 60)/3;
    for (int i =0; i < specifications.count; i++) {
        NSDictionary * dic = specifications[i];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(16, 15 + height, 200, 15)];
        label.text = [dic safeObjectForKey:@"name"];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:15];
        [self.ColorView addSubview:label];
        NSArray * specificationValues = [dic safeObjectForKey:@"specificationValues"];
        for (int j = 0; j < specificationValues.count; j++) {
            int x = j%3;
            int y = j/3;
            NSDictionary *dic1 = [specificationValues objectAtIndex:j];
            
            DDButton * button = [DDButton buttonWithType:UIButtonTypeCustom];
            button.dic = dic1;
            button.tag = i;
            NSLog(@"%ld",(long)button.tag);
            button.layer.borderWidth = 0.5;
            button.layer.cornerRadius = 2;
            button.frame = CGRectMake(10 + (buttonwidth + 20) * x, y * 42 +42 + height, buttonwidth, 34);
            [button setTitle:[dic1 safeObjectForKey:@"name"] forState:0];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:UIColorFromRGB(0xcccccc) forState:0];
            [self.ColorView addSubview:button];
            
            NSString * strID = [NSString stringWithFormat:@"%@",[dic1 safeObjectForKey:@"id"]];
            if ([self.firstID isEqualToString:strID] || [self.secondID isEqualToString:strID]) {
                button.layer.borderColor = UIColorFromRGB(0x20d994).CGColor;
                [button setTitleColor:UIColorFromRGB(0x20d994) forState:0];
                
            }else{
                button.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
                [button setTitleColor:UIColorFromRGB(0x333333) forState:0];
            }
            button.userInteractionEnabled = YES;
            [button addTarget:self action:@selector(chosenguige:) forControlEvents:UIControlEventTouchUpInside];
            [self.ColorView addSubview:button];
        }
        int x = (int)specificationValues.count%3;
        int y = (int)specificationValues.count/3;
        if (x > 0) {
            y ++ ;
        }
        height += 44 * (y + 1);
    }
    self.ColorHeight.constant = height > 140 ? height : 140;
    self.MainViewHeight.constant = self.ColorHeight.constant + 100;
}
-(void)chosenguige:(DDButton *)btn{
    if (btn.tag == 0) {
        self.firstID = [NSString stringWithFormat:@"%@",[btn.dic safeObjectForKey:@"id"]];
    }else
        self.secondID = [NSString stringWithFormat:@"%@",[btn.dic safeObjectForKey:@"id"]];
    
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:self.GoodsID forKey:@"productId"];
    NSMutableArray * array = [[NSMutableArray alloc]init];
    if (self.firstID.length > 0) {
        NSArray * specifications = [self.data safeObjectForKey:@"specifications"];
        NSDictionary * dic = specifications[0];
        NSString * ID = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"id"]];
        NSString * str = [NSString stringWithFormat:@"%@:%@",ID,self.firstID];
        [array addObject:str];
    }
    if (self.secondID.length > 0) {
        NSArray * specifications = [self.data safeObjectForKey:@"specifications"];
        NSDictionary * dic = specifications[1];
        NSString * ID = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"id"]];
        NSString * str = [NSString stringWithFormat:@"%@:%@",ID,self.secondID];
        [array addObject:str];
    }
    NSString * str = [array componentsJoinedByString:@","];
    [paraDic setObject:str forKey:@"specParam"];
    
    [NetWorkManager requestWithMethod:POST Url:GetProductDetail Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            [weakself createBigviewWith:[responseObject safeObjectForKey:@"data"]];
            [weakself createViewWith:[responseObject safeObjectForKey:@"data"]];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
-(void)jia:(DDButton *)btn{
    int stock =  [[self.data safeObjectForKey:@"stock"] intValue];
    if (GoodsCount >= stock) {
        [SVProgressHUD showErrorWithStatus:@"已到最大数量"];
        return;
    }
    GoodsCount += 1;
    self.CountLabel.text = [NSString stringWithFormat:@"%d",GoodsCount];
}
-(void)jian:(DDButton *)btn{
    if (GoodsCount <2) {
        [SVProgressHUD showErrorWithStatus:@"已到最小数量"];
        return;
    }
    GoodsCount -= 1;
    self.CountLabel.text = [NSString stringWithFormat:@"%d",GoodsCount];
}

-(void)addCart{

}
@end
