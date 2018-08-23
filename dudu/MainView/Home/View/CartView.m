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
    self.array = array;
    for (int i = 0; i<array.count; i++) {
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
        [view addSubview:title];
        
        [self.scroll addSubview:view];
    }
    self.scroll.contentSize = CGSizeMake(SCREEN_WIDTH, 46 * array.count);
}
-(void)add:(UIButton *)btn{
    
}
-(void)jian:(UIButton *)btn{
    
}

- (IBAction)deleteAll:(id)sender {
}
@end
