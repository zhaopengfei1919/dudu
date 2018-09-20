//
//  CartView.m
//  dudu
//
//  Created by apple on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CartView.h"

@implementation CartView

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapview:)];
    [self.BackView addGestureRecognizer:tap];
}
-(void)tapview:(UITapGestureRecognizer *)tap{
    self.hidden = YES;
}
-(void)setDic:(NSDictionary *)dic{
    NSArray * cartItems = [dic safeObjectForKey:@"cartItems"];
    self.Count.text = [NSString stringWithFormat:@"%lu",cartItems.count];
    
    float yajin = 0;
    for (int i =0; i<cartItems.count; i++) {
        NSDictionary * data = cartItems[i];
        NSDictionary * dic = [data safeObjectForKey:@"productInfo"];
        HomeModel * model = [HomeModel mj_objectWithKeyValues:dic];
        NSString * countstr = [NSString stringWithFormat:@"%@",[data safeObjectForKey:@"quantity"]];
        int quantity = [countstr intValue];
        yajin = yajin + model.boxPrice * quantity;
    }
    
    NSString * str = [NSString stringWithFormat:@"￥%.2f",yajin];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(1, string.length - 1)];
    self.Price.attributedText = string;
}
-(void)setArray:(NSArray *)array{
    _array = array;
    if (array.count < 5) {
        self.MainViewHeight.constant = array.count * 46 + 100;
    }else
        self.MainViewHeight.constant = 300;
    for (int i = 0; i<array.count; i++) {
        NSDictionary * dic = array[i];
        NSDictionary * productInfo = dic[@"productInfo"];
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 46 * i, SCREEN_WIDTH, 46)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(SCREEN_WIDTH - 36, 12, 21, 21);
        [btn1 setImage:[UIImage imageNamed:@"+"] forState:0];
        btn1.tag = i;
        [btn1 addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn1];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 15, 34, 16)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGB(0x20d944);
        label.font = [UIFont systemFontOfSize:15];
        label.text = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"quantity"]];
        [view addSubview:label];
        
        UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(SCREEN_WIDTH - 96, 12, 21, 21);
        [btn2 setImage:[UIImage imageNamed:@"_"] forState:0];
        btn2.tag = i;
        [btn2 addTarget:self action:@selector(jian:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn2];
        
        UILabel * pricelabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 170, 15, 70, 16)];
        pricelabel.textColor = UIColorFromRGB(0xf39700);
        pricelabel.font = [UIFont systemFontOfSize:15];
        pricelabel.textAlignment = NSTextAlignmentRight;
        [view addSubview:pricelabel];
        NSString * price = [NSString stringWithFormat:@"%@",[productInfo safeObjectForKey:@"price"]];
        float money = [price floatValue];
        NSString * str = [NSString stringWithFormat:@"￥%.2f",money];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(1, string.length - 1)];
        pricelabel.attributedText = string;
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(16, 15, SCREEN_WIDTH - 186, 16)];
        title.textColor = UIColorFromRGB(0x333333);
        title.font = [UIFont systemFontOfSize:15];
        title.text = [productInfo safeObjectForKey:@"name"];
        [view addSubview:title];
        
        [self.scroll addSubview:view];
    }
    self.scroll.contentSize = CGSizeMake(SCREEN_WIDTH, 46 * array.count);
}
-(void)add:(UIButton *)btn{
    NSDictionary *data = self.array[btn.tag];
    NSDictionary * dic = [data safeObjectForKey:@"productInfo"];
    HomeModel * model = [HomeModel mj_objectWithKeyValues:dic];
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    NSMutableDictionary * modeldic = @{}.mutableCopy;
    [modeldic setObject:model.ID forKey:@"id"];
    [paraDic setObject:modeldic forKey:@"productParam"];
    
    NSString * count = [NSString stringWithFormat:@"%@",[data safeObjectForKey:@"quantity"]];
    int quantity = [count intValue];
    quantity += 1;
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"quantity"];
    [self changecount:paraDic];
}

-(void)jian:(UIButton *)btn{
    NSDictionary *data = self.array[btn.tag];
    NSDictionary * dic = [data safeObjectForKey:@"productInfo"];
    HomeModel * model = [HomeModel mj_objectWithKeyValues:dic];
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    NSMutableDictionary * modeldic = @{}.mutableCopy;
    [modeldic setObject:model.ID forKey:@"id"];
    [paraDic setObject:modeldic forKey:@"productParam"];
    NSString * count = [NSString stringWithFormat:@"%@",[data safeObjectForKey:@"quantity"]];
    int quantity = [count intValue];
    if (quantity < 2) {
        [SVProgressHUD showErrorWithStatus:@"已到最小数量"];
        return;
    }
    [paraDic setObject:[NSNumber numberWithInt:-1] forKey:@"quantity"];
    [self changecount:paraDic];
}

-(void)changecount:(NSDictionary *)dic{
    WS(weakself);
    
    [NetWorkManager requestWithMethod:POST Url:CartChangeCount Parameters:dic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            if (weakself.CartBlock) {
                weakself.CartBlock();
            }
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
- (IBAction)deleteAll:(id)sender {
    WS(weakself);
    
    [NetWorkManager requestWithMethod:POST Url:CartClear Parameters:@{} success:^(id responseObject) {
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            if (weakself.CartBlock) {
                weakself.CartBlock();
            }
//            [self removeFromSuperview];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
@end
