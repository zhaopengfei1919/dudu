//
//  OrderListTableViewCell.m
//  dudu
//
//  Created by apple on 2018/9/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "OrderListTableViewCell.h"

@implementation OrderListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btn1.layer.cornerRadius = 1;
    self.btn1.layer.borderWidth = 1;
    self.btn1.layer.borderColor = UIColorFromRGB(0x666666).CGColor;
    
    self.btn2.layer.cornerRadius = 1;
    self.btn2.layer.borderWidth = 1;
    // Initialization code
}
-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.orderIdLabel.text = [NSString stringWithFormat:@"订单号：%@",[dic safeObjectForKey:@"id"]];
    self.dateLabel.text = [NSString stringWithFormat:@"下单时间：%@",[dic safeObjectForKey:@"createDate"]];
    NSString * orderStatus = [dic safeObjectForKey:@"orderStatus"];
    self.status.text = [NSString stringWithFormat:@"%@",orderStatus];
    if ([orderStatus isEqualToString:@"待付款"] || [orderStatus isEqualToString:@"待发货"] || [orderStatus isEqualToString:@"配送中"]) {
        self.status.textColor = UIColorFromRGB(0xf4b43a);
    }else if ([orderStatus isEqualToString:@"已取消"]){
        self.status.textColor = UIColorFromRGB(0xf43a3a);
    }else if ([orderStatus isEqualToString:@"已完成"]){
        self.status.textColor = UIColorFromRGB(0x20d994);
    }

    
    if ([orderStatus isEqualToString:@"待付款"]) {
        self.btn1.hidden = NO;
        [self.btn1 setTitle:@"取消订单" forState:0];
        [self.btn1 addTarget:self action:@selector(ordercancel) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btn2 setTitle:@"马上付款" forState:0];
        [self.btn2 setBackgroundColor:UIColorFromRGB(0xf4b43a)];
        [self.btn2 setTitleColor:[UIColor whiteColor] forState:0];
        [self.btn2 addTarget:self action:@selector(orderPay) forControlEvents:UIControlEventTouchUpInside];
    }else if ([orderStatus isEqualToString:@"待发货"]){
        self.btn1.hidden = YES;
        
        [self.btn2 setTitle:@"取消订单" forState:0];
        [self.btn2 setBackgroundColor:UIColorFromRGB(0xffffff)];
        [self.btn2 setTitleColor:UIColorFromRGB(0x666666) forState:0];
        self.btn2.layer.borderColor = UIColorFromRGB(0x888888).CGColor;
        [self.btn2 addTarget:self action:@selector(ordercancel) forControlEvents:UIControlEventTouchUpInside];
    }else if ([orderStatus isEqualToString:@"配送中"]){
        self.btn1.hidden = YES;
        
        [self.btn2 setTitle:@"取消订单" forState:0];
        [self.btn2 setBackgroundColor:UIColorFromRGB(0xffffff)];
        [self.btn2 setTitleColor:UIColorFromRGB(0x666666) forState:0];
        self.btn2.layer.borderColor = UIColorFromRGB(0x888888).CGColor;
        [self.btn2 addTarget:self action:@selector(ordercancel) forControlEvents:UIControlEventTouchUpInside];
    }else if ([orderStatus isEqualToString:@"已完成"]){
        self.btn1.hidden = NO;
        [self.btn1 setTitle:@"再来一单" forState:0];
        [self.btn1 addTarget:self action:@selector(orderAgain) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btn2 setTitle:@"评价/查看评价" forState:0];
        [self.btn2 setBackgroundColor:UIColorFromRGB(0x20d994)];
        [self.btn2 setTitleColor:[UIColor whiteColor] forState:0];
        [self.btn2 addTarget:self action:@selector(orderpingjia) forControlEvents:UIControlEventTouchUpInside];
    }else if ([orderStatus isEqualToString:@"已取消"]){
        self.btn1.hidden = YES;
        
        [self.btn2 setTitle:@"再来一单" forState:0];
        [self.btn2 setBackgroundColor:UIColorFromRGB(0xffffff)];
        [self.btn2 setTitleColor:UIColorFromRGB(0x666666) forState:0];
        self.btn2.layer.borderColor = UIColorFromRGB(0x888888).CGColor;
        [self.btn2 addTarget:self action:@selector(orderAgain) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([orderStatus isEqualToString:@"待付款"] || [orderStatus isEqualToString:@"已完成"]) {
        self.priceTop.constant = 25;
        self.Price2Label.hidden = YES;
    }else{
        self.priceTop.constant = 15;
        self.Price2Label.hidden = NO;
    }
    NSString * str = [NSString stringWithFormat:@"实付：￥%@",[dic safeObjectForKey:@"amount"]];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:NSMakeRange(0, 3)];
    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xf4b43a) range:NSMakeRange(3, string.length - 3)];
    self.PriceLabel.attributedText = string;
    
    NSArray * orderItems = [dic safeObjectForKey:@"orderItems"];
    int count = 0;
    for (int i =0 ; i<orderItems.count; i++) {
        NSDictionary * data = orderItems[i];
        NSString * qty = [NSString stringWithFormat:@"%@",[data safeObjectForKey:@"qty"]];
        count += [qty intValue];
        
        NSDictionary * productInfo = [data safeObjectForKey:@"productInfo"];
        NSString * image = [productInfo safeObjectForKey:@"image"];
        
        UIImageView * images = [[UIImageView alloc]initWithFrame:CGRectMake(70*i, 0, 60, 60)];
        [images sd_setImageWithURL:[NSURL URLWithString:image]];
        [self.ImageScroll addSubview:images];
    }
    self.ImageScroll.contentSize = CGSizeMake(70 * orderItems.count, 60);
    self.CountLabel.text = [NSString stringWithFormat:@"x%d",count];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)orderPay{
    
}
-(void)ordercancel{
//    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:[self.dic safeObjectForKey:@"id"] forKey:@"id"];
    
    [NetWorkManager requestWithMethod:POST Url:OrderCancel Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            

        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
-(void)orderAgain{
    
}
-(void)orderpingjia{
    
}
@end
