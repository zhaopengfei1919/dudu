//
//  ChosenTimeAndStyle.m
//  dudu
//
//  Created by apple on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ChosenTimeAndStyle.h"

@interface ChosenTimeAndStyle ()<UIPickerViewDelegate,UIPickerViewDataSource>

@end

@implementation ChosenTimeAndStyle

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if ([self.tyle isEqualToString:@"time"]) {
        self.timeView.hidden = NO;
        self.payView.hidden = YES;
    }else if ([self.tyle isEqualToString:@"pay"]) {
        self.timeView.hidden = YES;
        self.payView.hidden = NO;
        [self createbtn];
    }
}
-(void)createbtn{
    for (int i = 0; i<self.array.count; i++) {
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(11, 41 * i + 15, 25, 25)];
        image.image = [UIImage imageNamed:@"购物车商品未选中"];
        [self.scroll addSubview:image];
        
        DDButton * btn = [DDButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(11, 41 * i + 10, 300, 35);
        btn.dic = self.array[i];
        [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scroll addSubview:btn];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(41, 41 * i + 20, SCREEN_WIDTH - 55, 15)];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:15];
        label.text = [btn.dic safeObjectForKey:@"name"];
        [self.scroll addSubview:label];
    }
    self.scroll.contentSize = CGSizeMake(SCREEN_WIDTH, 41 * self.array.count);
}
-(void)btnclick:(DDButton *)btn{
    if (_chosenBlock) {
        self.chosenBlock(btn.dic);
        [self removeFromSuperview];
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.array.count;
    }
    NSInteger row1=[self.Picker selectedRowInComponent:0];
    NSDictionary * dic = self.array[row1];
    NSArray * selectTimes = [dic safeObjectForKey:@"selectTimes"];
    return selectTimes.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        NSDictionary * dic = self.array[row];
        return [dic safeObjectForKey:@"selectDay"];
    }
    NSInteger row1=[self.Picker selectedRowInComponent:0];
    NSDictionary * dic = self.array[row1];
    NSArray * selectTimes = [dic safeObjectForKey:@"selectTimes"];
    return selectTimes[row];
}
- (IBAction)timeSure:(id)sender {
    NSInteger row1=[self.Picker selectedRowInComponent:0];
    NSDictionary * date = self.array[row1];
    NSString * day = [date safeObjectForKey:@"selectDay"];
    NSInteger row2=[self.Picker selectedRowInComponent:1];
    NSArray * selectTimes = [date safeObjectForKey:@"selectTimes"];
    NSString * time = selectTimes[row2];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:day forKey:@"day"];
    [dic setObject:time forKey:@"time"];
    if (_chosenBlock) {
        self.chosenBlock(dic);
        [self removeFromSuperview];
    }
}

- (IBAction)cancel:(id)sender {
     [self removeFromSuperview];
}
@end
