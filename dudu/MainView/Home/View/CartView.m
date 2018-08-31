//
//  CartView.m
//  dudu
//
//  Created by apple on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CartView.h"

@implementation CartView



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
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(16, 15, SCREEN_WIDTH - 106, 16)];
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
