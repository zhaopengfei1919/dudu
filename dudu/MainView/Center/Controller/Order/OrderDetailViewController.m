//
//  OrderDetailViewController.m
//  dudu
//
//  Created by apple on 2018/9/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderTableViewCell.h"
#import "pingjiaViewController.h"

@interface OrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation OrderDetailViewController
-(void)orderdetail{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:self.orderid forKey:@"id"];
    
    [NetWorkManager requestWithMethod:POST Url:Orderdetail Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            self.data = [responseObject objectForKey:@"data"];
            NSArray * array = [responseObject objectForKey:@"data"][@"orderItems"];
            [weakself.dataSourse removeAllObjects];
            [weakself.dataSourse addObjectsFromArray:array];
            [weakself.table reloadData];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess:) name:@"PAY_SUCCESS" object:nil];
    ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFaile:) name:@"PAY_FAILE" object:nil];
    ;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PAY_SUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PAY_FAILE" object:nil];
}
- (void)paySuccess:(NSNotification *)notification{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)payFaile:(NSNotification *)notification{
    [SVProgressHUD showErrorWithStatus:@"支付失败"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourse = [[NSMutableArray alloc]init];
    [self orderdetail];
    
    adjustsScrollViewInsets_NO(self.table, self);
    [self.table registerNib:[UINib nibWithNibName:@"OrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderTableViewCell"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourse.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 142;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTableViewCell" forIndexPath:indexPath];
    NSDictionary * data = self.dataSourse[indexPath.row];
    NSDictionary * dic = [data safeObjectForKey:@"productInfo"];
    cell.model = [HomeModel mj_objectWithKeyValues:dic];
    cell.CountLabel.text = [NSString stringWithFormat:@"x%@",[data safeObjectForKey:@"qty"]];
    cell.ActuallyLabel.text = [NSString stringWithFormat:@"应发货%ld斤，实发货%ld斤，应收%.2f元，实收%.2f元",cell.model.weight,cell.model.weight,cell.model.weight*cell.model.unitPrice,cell.model.price];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 75, 15, 60, 15)];
    label1.textAlignment = NSTextAlignmentRight;
    NSString * orderStatus = [self.data safeObjectForKey:@"orderStatus"];
    label1.text = [NSString stringWithFormat:@"%@",orderStatus];
    if ([orderStatus isEqualToString:@"待付款"] || [orderStatus isEqualToString:@"待发货"] || [orderStatus isEqualToString:@"配送中"]) {
        label1.textColor = UIColorFromRGB(0xf4b43a);
    }else if ([orderStatus isEqualToString:@"已取消"]){
        label1.textColor = UIColorFromRGB(0xf43a3a);
    }else if ([orderStatus isEqualToString:@"已完成"]){
        label1.textColor = UIColorFromRGB(0x20d994);
    }
    label1.font = [UIFont systemFontOfSize:15];
    [view addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 100, 15)];
    NSString * name = [self.data safeObjectForKey:@"id"];
    label2.text = [NSString stringWithFormat:@"订单号：%@",name];
    label2.font = [UIFont systemFontOfSize:15];
    label2.textColor = UIColorFromRGB(0x333333);
    [view addSubview:label2];
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, SCREEN_WIDTH - 100, 12)];
    NSString * time = [self.data safeObjectForKey:@"createDate"];
    label3.text = [NSString stringWithFormat:@"下单时间：%@",time];
    label3.font = [UIFont systemFontOfSize:12];
    label3.textColor = UIColorFromRGB(0x888888);
    [view addSubview:label3];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 65;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 220, 15)];
    label2.font = [UIFont systemFontOfSize:15];
    label2.textColor = UIColorFromRGB(0x333333);
    [view addSubview:label2];
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, SCREEN_WIDTH - 220, 12)];
    label3.font = [UIFont systemFontOfSize:14];
    label3.textColor = UIColorFromRGB(0x666666);
    [view addSubview:label3];
    
    NSString * orderStatus = [self.data safeObjectForKey:@"orderStatus"];
    NSString * str = @"";
    if ([orderStatus isEqualToString:@"待付款"] || [orderStatus isEqualToString:@"已完成"]) {
        label2.frame = CGRectMake(15, 25, SCREEN_WIDTH - 220, 15);
        label3.hidden = YES;
        str = [NSString stringWithFormat:@"合计:￥%@",[self.data safeObjectForKey:@"amount"]];
    }else{
        label2.frame = CGRectMake(15, 15, SCREEN_WIDTH - 220, 15);
        label3.hidden = NO;
        str = [NSString stringWithFormat:@"实付:￥%@",[self.data safeObjectForKey:@"amount"]];
    }
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:NSMakeRange(0, 3)];
    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xf4b43a) range:NSMakeRange(3, string.length - 3)];
    label2.attributedText = string;
    
    NSString * offsetAmount = str = [NSString stringWithFormat:@"%@",[self.data safeObjectForKey:@"offsetAmount"]];
    if ([offsetAmount intValue] < 0) {
        offsetAmount = [offsetAmount substringFromIndex:1];
        label3.text = [NSString stringWithFormat:@"实收:￥%@，应找:￥%@",[self.data safeObjectForKey:@"payAmount"],offsetAmount];
    }else{
        label3.text = [NSString stringWithFormat:@"实收:￥%@，应收:￥%@",[self.data safeObjectForKey:@"payAmount"],offsetAmount];
    }
    
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(SCREEN_WIDTH - 200, 15, 90, 34);
    [btn1 setTitleColor:UIColorFromRGB(0x666666) forState:0];
    btn1.titleLabel.font = [UIFont systemFontOfSize:15];
    btn1.layer.cornerRadius = 3;
    btn1.layer.borderWidth = 0.5;
    btn1.layer.borderColor = UIColorFromRGB(0x666666).CGColor;
    [view addSubview:btn1];
    
    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(SCREEN_WIDTH - 100, 15, 90, 34);
    [btn2 setTitleColor:UIColorFromRGB(0x666666) forState:0];
    btn2.titleLabel.font = [UIFont systemFontOfSize:15];
    btn2.layer.cornerRadius = 3;
    btn2.layer.borderWidth = 0.5;
    [view addSubview:btn2];
    
    
    if ([orderStatus isEqualToString:@"待付款"]) {
        btn1.hidden = NO;
        [btn1 setTitle:@"取消订单" forState:0];
        [btn1 addTarget:self action:@selector(ordercancel) forControlEvents:UIControlEventTouchUpInside];
        
        [btn2 setTitle:@"马上付款" forState:0];
        [btn2 setBackgroundColor:UIColorFromRGB(0xf4b43a)];
        [btn2 setTitleColor:[UIColor whiteColor] forState:0];
        [btn2 addTarget:self action:@selector(orderPay) forControlEvents:UIControlEventTouchUpInside];
        btn2.layer.borderWidth = 0;
    }else if ([orderStatus isEqualToString:@"待发货"]){
        btn1.hidden = YES;
        
        [btn2 setTitle:@"取消订单" forState:0];
        [btn2 setBackgroundColor:UIColorFromRGB(0xffffff)];
        [btn2 setTitleColor:UIColorFromRGB(0x666666) forState:0];
        btn2.layer.borderColor = UIColorFromRGB(0x888888).CGColor;
        [btn2 addTarget:self action:@selector(ordercancel) forControlEvents:UIControlEventTouchUpInside];
    }else if ([orderStatus isEqualToString:@"配送中"]){
        btn1.hidden = YES;
        
        [btn2 setTitle:@"取消订单" forState:0];
        [btn2 setBackgroundColor:UIColorFromRGB(0xffffff)];
        [btn2 setTitleColor:UIColorFromRGB(0x666666) forState:0];
        btn2.layer.borderColor = UIColorFromRGB(0x888888).CGColor;
        [btn2 addTarget:self action:@selector(ordercancel) forControlEvents:UIControlEventTouchUpInside];
    }else if ([orderStatus isEqualToString:@"已完成"]){
        btn1.hidden = YES;
        
        [btn2 setTitle:@"再来一单" forState:0];
        [btn2 setTitleColor:UIColorFromRGB(0x20d994) forState:0];
        btn2.layer.borderColor = UIColorFromRGB(0x20d994).CGColor;
        [btn2 addTarget:self action:@selector(orderAgain) forControlEvents:UIControlEventTouchUpInside];
        btn2.layer.borderWidth = 0;
        
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, 10)];
        line.backgroundColor = UIColorFromRGB(0xf5f5f9);
        [view addSubview:line];
        
        UILabel * pingjia = [[UILabel alloc]initWithFrame:CGRectMake(12, 75, 80, 45)];
        pingjia.font = [UIFont systemFontOfSize:15];
        pingjia.textColor = UIColorFromRGB(0x333333);
        pingjia.text = @"我的评价";
        [view addSubview:pingjia];
        
        UIImageView * images = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 28, 91, 13, 13)];
        images.image = [UIImage imageNamed:@"选择箭头"];
        [view addSubview:images];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 75, SCREEN_WIDTH, 45);
        [button addTarget:self action:@selector(orderpingjia) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }else if ([orderStatus isEqualToString:@"已取消"]){
        btn1.hidden = YES;
        
        [btn2 setTitle:@"再来一单" forState:0];
        [btn2 setBackgroundColor:UIColorFromRGB(0xffffff)];
        [btn2 setTitleColor:UIColorFromRGB(0x666666) forState:0];
        btn2.layer.borderColor = UIColorFromRGB(0x888888).CGColor;
        [btn2 addTarget:self action:@selector(orderpingjia) forControlEvents:UIControlEventTouchUpInside];
    }
    return view;
}
-(void)orderPay{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:[self.data safeObjectForKey:@"sn"] forKey:@"orderSN"];
    
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
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:[self.data safeObjectForKey:@"id"] forKey:@"id"];
    
    [NetWorkManager requestWithMethod:POST Url:OrderCancel Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"取消订单成功"];
            [weakself.navigationController popViewControllerAnimated:YES];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
-(void)orderAgain{
    
}
-(void)orderpingjia{
    id object = [self nextResponder];
    while (![object isKindOfClass:[UIViewController class]] && object != nil) {
        object = [object nextResponder];
    }
    UIViewController *superController = (UIViewController*)object;
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    pingjiaViewController * pingjia = [sb instantiateViewControllerWithIdentifier:@"pingjiaViewController"];
    pingjia.orderid = [NSString stringWithFormat:@"%@",[self.data safeObjectForKey:@"id"]];
    pingjia.goodsArray = [self.data safeObjectForKey:@"orderItems"];
    [superController.navigationController pushViewController:pingjia animated:YES];
}
@end
