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
    yanseID = @"";
    guigeID = @"";
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
    itemStock = [[MyData safeObjectForKey:@"itemStock"] intValue];
    
    self.PriceLabel.text = [NSString stringWithFormat:@"%@",[MyData safeObjectForKey:@"itemPrice"]];
//    [self.MainImage setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@480w",[MyData safeObjectForKey:@"itemImage"]]] placeholder:[UIImage imageNamed:@"load_huancun"]];
    [self.MainImage sd_setImageWithURL:[NSURL URLWithString:@""]];
    self.MainLabel.text = @"";
    
    self.Jia.userInteractionEnabled = YES;
    self.Jian.userInteractionEnabled = YES;
    self.MainImage.layer.cornerRadius = 2;
}
-(void)createBigviewWith:(NSDictionary *)data{
    [self.SureBtn addTarget:self action:@selector(addCart) forControlEvents:UIControlEventTouchUpInside];
    [self.Jia addTarget:self action:@selector(jia:) forControlEvents:UIControlEventTouchUpInside];
    [self.Jian addTarget:self action:@selector(jian:) forControlEvents:UIControlEventTouchUpInside];
    if (self.yanse.length > 0) {
        yanseID = self.yanse;
        self.yanse = @"";
    }
    if (self.guige.length > 0) {
        guigeID = self.guige;
        self.guige = @"";
    }
    if (self.count.length > 0) {
        Cartcount = [self.count intValue];
        self.count = @"";
    }
    
    self.data = data;
//    self.Name1.text = [data safeObjectForKey:@"itemStandardFirstName"];
//    self.Name2.text = [data safeObjectForKey:@"itemStandardSecondName"];
    
    itemStock = [[data safeObjectForKey:@"itemStock"] intValue];
    
    NSArray *itemFirstStandard = [data safeObjectForKey:@"itemFirstStandard"];
    NSArray *itemSecondStandard = [data safeObjectForKey:@"itemSecondStandard"];
    
    NSInteger height = 60;
    //颜色
    for (UIView *vi in self.ColorView.subviews) {
        if ([vi isKindOfClass:[DDButton class]]) {
            [vi removeFromSuperview];
        }
    }
    if (itemFirstStandard.count == 0) {
        self.ColorView.hidden = YES;
    }else{
        float width = 40;
        float buttonwidth = 19;
        int x = 0;
        for (int i=0; i<itemFirstStandard.count; i++) {
            NSDictionary *dic1 = [itemFirstStandard objectAtIndex:i];
            NSString * itemName = [dic1 safeObjectForKey:@"itemName"];
            NSString * itemRemark = [dic1 safeObjectForKey:@"itemRemark"];
            NSString * btntitle = @"";
            if (itemRemark.length > 0) {
                btntitle = [NSString stringWithFormat:@"%@",itemRemark];
            }else
                btntitle = [NSString stringWithFormat:@"%@",itemName];
            
            CGSize size = [[FYUser userInfo] sizeForString:btntitle withFontSize:11 withWidth:280];
            width = width + size.width + 20;
            if (buttonwidth + size.width > SCREEN_WIDTH - 20) {
                width = 40;
                buttonwidth = 19;
                x++;
            }
            //NSLog(@"%f,%f,%f",width,size.width,buttonwidth);
            DDButton * button = [DDButton buttonWithType:UIButtonTypeCustom];
            button.dic = dic1;
            button.layer.borderWidth = 0.5;
            button.layer.cornerRadius = 2;
            button.frame = CGRectMake(buttonwidth, x * 29 +42, size.width + 24, 24);
            buttonwidth = buttonwidth + size.width + 34;
            [button setTitle:btntitle forState:0];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button setTitleColor:UIColorFromRGB(0xcdcdcd) forState:0];
            [self.ColorView addSubview:button];
            
            NSString *itemStock1 = [dic1 safeObjectForKey:@"itemStock"];
            if ([itemStock1 intValue] == 0) {
                [button setBackgroundColor:UIColorFromRGB(0xf3f5f7)];
                button.layer.borderColor = UIColorFromRGB(0xcdcdcd).CGColor;
                button.userInteractionEnabled = NO;
                [button setTitleColor:[UIColor lightGrayColor] forState:0];
            }else{
                if ([yanseID isEqualToString:[dic1 safeObjectForKey:@"itemId"]]) {
                    [button setBackgroundColor:UIColorFromRGB(0xd2af78)];
                    button.layer.borderColor = UIColorFromRGB(0xd2af78).CGColor;
                    [button setTitleColor:[UIColor whiteColor] forState:0];
                    
                }else{
                    [button setBackgroundColor:UIColorFromRGB(0xffffff)];
                    button.layer.borderColor = UIColorFromRGB(0xcdcdcd).CGColor;
                    [button setTitleColor:UIColorFromRGB(0x3d3d3d) forState:0];
                }
                button.userInteractionEnabled = YES;
            }
            button.tag = i + 1;
            [button addTarget:self action:@selector(ColorChoose:) forControlEvents:UIControlEventTouchUpInside];
        }
        self.ColorHeight.constant = (x + 1) * 33 + 33;
        height += (x + 1) * 33 + 33;
    }
    
    //    //尺寸
    for (UIView *vi in self.SizeView.subviews) {
        if ([vi isKindOfClass:[DDButton class]]) {
            [vi removeFromSuperview];
        }
    }
    if (itemSecondStandard.count == 0) {
        self.SizeView.hidden = YES;
    }else{
        float width = 40;
        float buttonwidth = 19;
        int x = 0;
        for (int i=0; i<itemSecondStandard.count; i++) {
            NSDictionary *dic1 = [itemSecondStandard objectAtIndex:i];
            NSString * itemName = [dic1 safeObjectForKey:@"itemName"];
            NSString * itemRemark = [dic1 safeObjectForKey:@"itemRemark"];
            NSString * btntitle = @"";
            if (itemRemark.length > 0) {
                btntitle = [NSString stringWithFormat:@"%@",itemRemark];
            }else
                btntitle = [NSString stringWithFormat:@"%@",itemName];
            
            CGSize size = [[FYUser userInfo] sizeForString:btntitle withFontSize:11 withWidth:280];
            width = width + size.width + 20;
            if (buttonwidth + size.width > SCREEN_WIDTH - 20) {
                width = 40;
                buttonwidth = 19;
                x++;
            }
            //NSLog(@"%f,%f,%f",width,size.width,buttonwidth);
            DDButton * button = [DDButton buttonWithType:UIButtonTypeCustom];
            button.dic = dic1;
            button.layer.borderWidth = 0.5;
            button.layer.cornerRadius = 2;
            button.frame = CGRectMake(buttonwidth, x * 29 +42, size.width + 24, 24);
            buttonwidth = buttonwidth + size.width + 34;
            [button setTitle:btntitle forState:0];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button setTitleColor:UIColorFromRGB(0xcdcdcd) forState:0];
            [self.SizeView addSubview:button];
            
            NSString *itemStock1 = [dic1 safeObjectForKey:@"itemStock"];
            if ([itemStock1 intValue] == 0) {
                [button setBackgroundColor:UIColorFromRGB(0xf3f5f7)];
                button.layer.borderColor = UIColorFromRGB(0xcdcdcd).CGColor;
                button.userInteractionEnabled = NO;
                [button setTitleColor:[UIColor lightGrayColor] forState:0];
            }else{
                if ([guigeID isEqualToString:[dic1 safeObjectForKey:@"itemId"]]) {
                    [button setBackgroundColor:UIColorFromRGB(0xd2af78)];
                    button.layer.borderColor = UIColorFromRGB(0xd2af78).CGColor;
                    [button setTitleColor:[UIColor whiteColor] forState:0];
                }else{
                    [button setBackgroundColor:UIColorFromRGB(0xffffff)];
                    button.layer.borderColor = UIColorFromRGB(0xcdcdcd).CGColor;
                    [button setTitleColor:UIColorFromRGB(0x3d3d3d) forState:0];
                }
                button.userInteractionEnabled = YES;
            }
            button.tag = i + 1;
            [button addTarget:self action:@selector(SizeChoose:) forControlEvents:UIControlEventTouchUpInside];
        }
        self.SizeHeight.constant = (x + 1) * 33 + 33;
        height += (x + 1) * 33 + 33;
    }
    self.Jian.userInteractionEnabled = NO;
    if (height < 210) {
        height = 210;
    }
    self.MainViewHeight.constant = height;
    self.CountLabel.text = [NSString stringWithFormat:@"%d",Cartcount];
    if (itemStock == 0) {
        self.CountLabel.text = [NSString stringWithFormat:@"0"];
        [self.Jia setBackgroundImage:[UIImage imageNamed:@"gwc_s_add_gray"] forState:0];
        [self.Jian setBackgroundImage:[UIImage imageNamed:@"gwc_s_add_gray"] forState:0];
        self.Jia.userInteractionEnabled = NO;
        self.Jian.userInteractionEnabled = NO;
        self.SureBtn.backgroundColor = UIColorFromRGB(0xcdcdcd);
        self.TishiLabel.hidden = NO;
        self.Bottom.constant = 30;
    }else{
        if (Cartcount > 1) {
            [self.Jian setBackgroundImage:[UIImage imageNamed:@"gwc_s_minus_black"] forState:0];
            self.Jian.userInteractionEnabled = YES;
        }
        self.SureBtn.backgroundColor = UIColorFromRGB(0xd2af78);
        self.TishiLabel.hidden = YES;
        self.Bottom.constant = 0;
    }
}
- (void)ColorChoose:(id)sender
{
    Cartcount = 1;
    self.Jian.userInteractionEnabled = NO;
    [self.Jian setBackgroundImage:[UIImage imageNamed:@"gwc_s_minus_gray"] forState:0];
    self.CountLabel.text = [NSString stringWithFormat:@"%d",Cartcount];
    
    DDButton *btn = (DDButton *)sender;
    NSDictionary *dic = btn.dic;
    
    if ([yanseID isEqualToString:@""]) {
        yanseID = [dic safeObjectForKey:@"itemId"];
        yanseName = [dic safeObjectForKey:@"itemName"];
    }else{
        if ([yanseID isEqualToString:[dic safeObjectForKey:@"itemId"]]) {
            yanseID = @"";
            yanseName = @"";
        }else{
            yanseID = [dic safeObjectForKey:@"itemId"];
            yanseName = [dic safeObjectForKey:@"itemName"];
        }
    }
    NSMutableDictionary * oderm = [[NSMutableDictionary alloc]init];
    [oderm setObject:[self.data safeObjectForKey:@"itemId"] forKey:@"commodityId"];
    [oderm setObject:yanseID forKey:@"firstId"];
    [oderm setObject:guigeID forKey:@"secondId"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"commodityStandard" object:oderm userInfo:nil];
}
- (void)SizeChoose:(id)sender
{
    Cartcount = 1;
    self.Jian.userInteractionEnabled = NO;
    [self.Jian setBackgroundImage:[UIImage imageNamed:@"gwc_s_minus_gray"] forState:0];
    self.CountLabel.text = [NSString stringWithFormat:@"%d",Cartcount];
    
    DDButton *btn = (DDButton *)sender;
    NSDictionary *dic = btn.dic;
    
    if ([guigeID isEqualToString:@""]) {
        guigeID = [dic safeObjectForKey:@"itemId"];
        guigeName = [dic safeObjectForKey:@"itemName"];
        
    }else{
        if ([guigeID isEqualToString:[dic objectForKey:@"itemId"]]) {
            guigeID = @"";
            guigeName = @"";
        }else{
            guigeID = [dic safeObjectForKey:@"itemId"];
            guigeName = [dic safeObjectForKey:@"itemName"];
        }
    }
    NSMutableDictionary * oderm = [[NSMutableDictionary alloc]init];
    [oderm setObject:[self.data safeObjectForKey:@"itemId"] forKey:@"commodityId"];
    [oderm setObject:yanseID forKey:@"firstId"];
    [oderm setObject:guigeID forKey:@"secondId"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"commodityStandard" object:oderm userInfo:nil];
}
-(void)jia:(UIButton *)btn{
    if (itemStock == 0) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"库存总数:%d",itemStock]];
        return;
    }
    Cartcount ++;
    if (Cartcount > itemStock) {
        Cartcount = itemStock;
        self.Jia.userInteractionEnabled = NO;
        [self.Jia setBackgroundImage:[UIImage imageNamed:@"gwc_s_add_gray"] forState:0];
    }
    self.CountLabel.text = [NSString stringWithFormat:@"%d",Cartcount];
    [self.Jian setBackgroundImage:[UIImage imageNamed:@"gwc_s_minus_black"] forState:0];
    self.Jian.userInteractionEnabled = YES;
}
-(void)jian:(UIButton *)btn{
    if (itemStock == 0) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"库存总数:%d",itemStock]];
        return;
    }
    
    Cartcount --;
    
    if (Cartcount < 1) {
        Cartcount = 1;
        self.Jian.userInteractionEnabled = NO;
        [self.Jian setBackgroundImage:[UIImage imageNamed:@"gwc_s_minus_gray"] forState:0];
    }
    self.CountLabel.text = [NSString stringWithFormat:@"%d",Cartcount];
    [self.Jia setBackgroundImage:[UIImage imageNamed:@"gwc_s_add_black"] forState:0];
    self.Jia.userInteractionEnabled = YES;
}

-(void)addCart{
    NSArray *itemFirstStandard = [self.data safeObjectForKey:@"itemFirstStandard"];
    NSArray *itemSecondStandard = [self.data safeObjectForKey:@"itemSecondStandard"];
    
    if ([yanseID isEqualToString:@""] && itemFirstStandard.count != 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择商品颜色"];
        return;
    }
    if ([guigeID isEqualToString:@""] && itemSecondStandard.count != 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择商品颜色"];
        return;
    }
    
    if (itemStock == 0) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"库存总数:%d",itemStock]];
        return;
    }
    
    if (Cartcount > itemStock){
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"库存总数:%d",itemStock]];
        return;
    }
    NSMutableDictionary * oderParams = [[NSMutableDictionary alloc] init];
    [oderParams setObject:self.cartid forKey:@"cartId"];
    [oderParams setObject:[FYUser userInfo].userId forKey:@"userId"];
    [oderParams setObject:[self.data safeObjectForKey:@"itemId"] forKey:@"commodityId"];
    [oderParams setObject:yanseID forKey:@"firstId"];
    [oderParams setObject:guigeID forKey:@"secondId"];
    [oderParams setObject:[NSString stringWithFormat:@"%d",Cartcount] forKey:@"stock"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"carteditNew" object:oderParams userInfo:nil];
}
@end
