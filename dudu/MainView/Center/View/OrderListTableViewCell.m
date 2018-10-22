//
//  OrderListTableViewCell.m
//  dudu
//
//  Created by apple on 2018/9/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "OrderListTableViewCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "pingjiaViewController.h"
#import "AddOrderViewController.h"
#import "ShopCartViewController.h"

@interface OrderListTableViewCell()

@end

@implementation OrderListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btn1.layer.cornerRadius = 3;
    self.btn1.layer.borderWidth = 0.5;
    self.btn1.layer.borderColor = UIColorFromRGB(0x666666).CGColor;
    
    self.btn2.layer.cornerRadius = 3;
    self.btn2.layer.borderWidth = 0.5;
    // Initialization code
}
-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.orderIdLabel.text = [NSString stringWithFormat:@"订单号：%@",[dic safeObjectForKey:@"sn"]];
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

    [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    [self.btn2 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    self.btn2.layer.borderWidth = 0.5;
    if ([orderStatus isEqualToString:@"待付款"]) {
        self.btn1.hidden = NO;
        [self.btn1 setTitle:@"取消订单" forState:0];
        [self.btn1 addTarget:self action:@selector(ordercancel) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btn2 setTitle:@"马上付款" forState:0];
        [self.btn2 setBackgroundColor:UIColorFromRGB(0xf4b43a)];
        [self.btn2 setTitleColor:[UIColor whiteColor] forState:0];
        [self.btn2 addTarget:self action:@selector(orderPay) forControlEvents:UIControlEventTouchUpInside];
        self.btn2.layer.borderWidth = 0;
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
        self.btn2.layer.borderWidth = 0;
    }else if ([orderStatus isEqualToString:@"已取消"]){
        self.btn1.hidden = YES;
        
        [self.btn2 setTitle:@"再来一单" forState:0];
        [self.btn2 setBackgroundColor:UIColorFromRGB(0xffffff)];
        [self.btn2 setTitleColor:UIColorFromRGB(0x666666) forState:0];
        self.btn2.layer.borderColor = UIColorFromRGB(0x888888).CGColor;
        [self.btn2 addTarget:self action:@selector(orderAgain) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSString * str = @"";
    if ([orderStatus isEqualToString:@"待付款"] || [orderStatus isEqualToString:@"已完成"]) {
        self.priceTop.constant = 25;
        self.Price2Label.hidden = YES;
        str = [NSString stringWithFormat:@"合计:￥%@",[dic safeObjectForKey:@"amount"]];
    }else{
        self.priceTop.constant = 15;
        self.Price2Label.hidden = NO;
        str = [NSString stringWithFormat:@"合计:￥%@",[dic safeObjectForKey:@"amount"]];
    }
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:NSMakeRange(0, 3)];
    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xf4b43a) range:NSMakeRange(3, string.length - 3)];
    self.PriceLabel.attributedText = string;
    
    NSString * offsetAmount = str = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"offsetAmount"]];
    if ([offsetAmount intValue] < 0) {
        offsetAmount = [offsetAmount substringFromIndex:1];
        self.Price2Label.text = [NSString stringWithFormat:@"实收:￥%@，应找:￥%@",[dic safeObjectForKey:@"payAmount"],offsetAmount];
    }else{
        self.Price2Label.text = [NSString stringWithFormat:@"实收:￥%@，应收:￥%@",[dic safeObjectForKey:@"payAmount"],offsetAmount];
    }
    
    
    NSArray * orderItems = [dic safeObjectForKey:@"orderItems"];
    int count = 0;
    for (UIImageView * image in self.ImageScroll.subviews) {
        [image removeFromSuperview];
    }
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
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:[self.dic safeObjectForKey:@"sn"] forKey:@"orderSN"];
    
    [NetWorkManager requestWithMethod:POST Url:OrderPay Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSDictionary * data = [responseObject safeObjectForKey:@"data"];
            NSString * paymentMethonCode = [data safeObjectForKey:@"paymentMethonCode"];//付款code，alipay:支付宝 wxpay:微信支付 cash:货到付款
            if ([paymentMethonCode isEqualToString:@"alipay"]) {//duoduoAlipay
                NSDictionary * aliPayResult = [data safeObjectForKey:@"aliPayResult"];
                [weakself alipay:aliPayResult];
            }else if ([paymentMethonCode isEqualToString:@"wxpay"]){
                NSDictionary * wxPayResult = [data safeObjectForKey:@"wxPayResult"];
                [weakself wxpay:wxPayResult];
            }
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
-(void)alipay:(NSDictionary *)dic{
    NSString *appScheme = @"duoduoAlipay";
    NSString * orderInfo = [dic safeObjectForKey:@"orderInfo"];
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderInfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
}
-(void)wxpay:(NSDictionary *)dic{
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = [dic safeObjectForKey:@"partnerId"];
    request.prepayId= [dic safeObjectForKey:@"prepayId"];
    request.package = [dic safeObjectForKey:@"packageValue"];
    request.nonceStr= [dic safeObjectForKey:@"nonceStr"];
    NSMutableString *stamp  = [dic objectForKey:@"timeStamp"];
    request.timeStamp= [stamp intValue];
    request.sign= [dic safeObjectForKey:@"sign"];
    [WXApi sendReq:request];
}
-(void)ordercancel{
//    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:[self.dic safeObjectForKey:@"id"] forKey:@"id"];
    
    [NetWorkManager requestWithMethod:POST Url:OrderCancel Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"取消订单成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadtable" object:nil];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
-(void)orderAgain{
    id object = [self nextResponder];
    while (![object isKindOfClass:[UIViewController class]] && object != nil) {
        object = [object nextResponder];
    }
    UIViewController *superController = (UIViewController*)object;
    
    //    WS(weakself);
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSMutableArray * selectarray = [[NSMutableArray alloc]init];
    NSArray * orderItems = [self.dic safeObjectForKey:@"orderItems"];
    for (NSDictionary * dic in orderItems) {
        NSDictionary * data = [dic safeObjectForKey:@"productInfo"];
        HomeModel * model = [HomeModel mj_objectWithKeyValues:data];
        NSMutableDictionary * paraDic = @{}.mutableCopy;
        NSMutableDictionary * modeldic = @{}.mutableCopy;
        [modeldic setObject:model.ID forKey:@"id"];
        [paraDic setObject:modeldic forKey:@"productParam"];
        NSString * count = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"qty"]];
        [paraDic setObject:count forKey:@"quantity"];
        [array addObject:paraDic];
        
        NSMutableDictionary * product = [[NSMutableDictionary alloc]initWithDictionary:dic];
        [product removeObjectForKey:@"orderPrice"];
        [product removeObjectForKey:@"orderWeight"];
        [product removeObjectForKey:@"realPrice"];
        [product removeObjectForKey:@"realWeight"];
        [product setObject:[product safeObjectForKey:@"qty"] forKey:@"quantity"];
        [product removeObjectForKey:@"qty"];
        [selectarray addObject:product];
    }
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:array forKey:@"cartItemParams"];
    
    [NetWorkManager requestWithMethod:POST Url:CartAdds Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ShopCartViewController * shopcart = [sb instantiateViewControllerWithIdentifier:@"ShopCartViewController"];
            shopcart.listarray = selectarray;
            [superController.navigationController pushViewController:shopcart animated:YES];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
-(void)orderpingjia{
    id object = [self nextResponder];
    while (![object isKindOfClass:[UIViewController class]] && object != nil) {
        object = [object nextResponder];
    }
    UIViewController *superController = (UIViewController*)object;
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    pingjiaViewController * pingjia = [sb instantiateViewControllerWithIdentifier:@"pingjiaViewController"];
    pingjia.orderid = [NSString stringWithFormat:@"%@",[self.dic safeObjectForKey:@"id"]];
    pingjia.goodsArray = [self.dic safeObjectForKey:@"orderItems"];
    [superController.navigationController pushViewController:pingjia animated:YES];
}
@end
