//
//  AddOrderViewController.m
//  dudu
//
//  Created by apple on 2018/8/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AddOrderViewController.h"
#import "OrderTableViewCell.h"
#import "OrderListViewController.h"

@interface AddOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@end

@implementation AddOrderViewController
-(void)checkorder{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:self.listArray forKey:@"cartItemParamList"];
    
    [NetWorkManager requestWithMethod:POST Url:CheckOrder Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            self.data = [responseObject safeObjectForKey:@"data"];
            NSArray * data = [responseObject safeObjectForKey:@"data"][@"carts"];
            [weakself.dataSourse removeAllObjects];
            [weakself.dataSourse addObjectsFromArray:data];
            [weakself.table reloadData];
            [weakself checkPrice];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
//购物车数量
-(void)cartcount{
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:[FYUser userInfo].token forKey:@"token"];
    [NetWorkManager requestWithMethod:POST Url:CartCount Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code intValue] == 0) {
            int data = [[responseObject safeObjectForKey:@"data"] intValue];
            if (data > 0) {
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                BaseTableBarControllerView *tabbar = (BaseTableBarControllerView *)delegate.window.rootViewController;
                [tabbar.tabBar showBadgeOnItemIndex:2 Withnum:data];
            }
        }
    } requestRrror:^(id requestRrror) {
        
    }];
}
#pragma mark --键盘的显示隐藏--
-(void)keyboardWillShow:(NSNotification *)notification{
    //键盘最后的frame
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    //需要移动的距离
    if (height > 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableBottom.constant = height - 77;
        }];
    }
}
-(void)keyboardWillHide:(NSNotification *)notification{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableBottom.constant = 0;
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkPrice) name:@"chosenCoupon" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess:) name:@"PAY_SUCCESS" object:nil];
    ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFaile:) name:@"PAY_FAILE" object:nil];
    ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chosenCoupon" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PAY_SUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PAY_FAILE" object:nil];
}

- (void)paySuccess:(NSNotification *)notification{
    [self cartcount];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OrderListViewController * order = [sb instantiateViewControllerWithIdentifier:@"OrderListViewController"];
    order.status = @"2";
    [self.navigationController pushViewController:order animated:YES];
}
- (void)payFaile:(NSNotification *)notification{
    [SVProgressHUD showErrorWithStatus:@"支付失败"];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OrderListViewController * order = [sb instantiateViewControllerWithIdentifier:@"OrderListViewController"];
    order.status = @"1";
    [self.navigationController pushViewController:order animated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}

-(void)checkPrice{
    NSDictionary * addressdic = [self.data safeObjectForKey:@"receiverInfo"];
    if (addressdic.count > 0) {
        addressModel * model = [addressModel mj_objectWithKeyValues:addressdic];
        self.headerView.addressID = model.ID;
        [self.headerView.chosenBtn setTitle:@"" forState:0];
        [self.headerView.chosenBtn setBackgroundColor:[UIColor clearColor]];
        self.headerView.nameLabel.text = [NSString stringWithFormat:@"%@ %@",model.consignee,model.phone];
        NSDictionary * areaInfo =model.areaInfo;
        self.headerView.areaLabel.text = [NSString stringWithFormat:@"上海市%@%@",[areaInfo safeObjectForKey:@"name"],model.address];
    }
    
    float productAmount = [[NSString stringWithFormat:@"%@",[self.data safeObjectForKey:@"productAmount"]] floatValue];
    self.footerView.AllPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",productAmount];
    
    float boxAmount = [[NSString stringWithFormat:@"%@",[self.data safeObjectForKey:@"boxAmount"]] floatValue];
    float freight = [[NSString stringWithFormat:@"%@",[self.data safeObjectForKey:@"freight"]] floatValue];
    productAmount = productAmount + boxAmount + freight;
    if (![self.headerView.payLabel.text isEqualToString:@"点击选择"]) {
        if (self.headerView.methons == 0) {
            float onlineDiscount = [[NSString stringWithFormat:@"%@",[self.data safeObjectForKey:@"onlineDiscount"]] floatValue];
            self.footerView.payMoney.text = [NSString stringWithFormat:@"-￥%.2f",onlineDiscount];
            productAmount -= onlineDiscount;
        }else{
            self.footerView.payMoney.text = @"￥0.00";
        }
    }else{
        self.footerView.payMoney.text = @"￥0.00";
    }
    self.footerView.yajinLabel.text = [NSString stringWithFormat:@"+￥%.2f",boxAmount];
    self.footerView.yunfeiLabel.text = [NSString stringWithFormat:@"+￥%.2f",freight];
    
    NSArray * giftItemInfos = [self.data safeObjectForKey:@"giftItemInfos"];
    if (giftItemInfos.count == 0) {
        self.footerView.GiftLabel.text = @"无可用";
        self.footerView.giftBtn.enabled = NO;
    }else{
        self.footerView.giftBtn.enabled = YES;
        self.footerView.GiftLabel.text = @"点击选择";
        self.footerView.giftArray = giftItemInfos;
    }
    
    NSArray * anHaos = [self.data safeObjectForKey:@"anHaos"];
    if (anHaos.count == 0) {
        self.footerView.couponLabel.text = @"无可用";
        self.footerView.CouponBtn.enabled = NO;
        self.footerView.couponMoney.text = @"￥0.00";
    }else{
        self.footerView.CouponBtn.enabled = YES;
        if (![self.footerView.couponLabel.text isEqualToString:@"点击选择"]) {
            float amount = self.footerView.coumodel.amount;
            productAmount = productAmount - amount;
            self.footerView.couponMoney.text = [NSString stringWithFormat:@"-￥%.2f",amount];
        }else
            self.footerView.couponMoney.text = @"￥0.00";
    }
    
    NSInteger userPoint = [[NSString stringWithFormat:@"%@",[self.data safeObjectForKey:@"userPoint"]] integerValue];
    if (userPoint == 0) {
        self.footerView.jifenLabel.text = @"无可用积分";
        self.footerView.jifenBtn.enabled = NO;
        self.footerView.jifenMoney.text = @"￥0.00";
    }else{
        float jifenprice = (float)userPoint/100;
        self.footerView.jifenLabel.text = [NSString stringWithFormat:@"积分抵扣%.2f元",jifenprice];
        self.footerView.jifenBtn.enabled = YES;
        if (self.footerView.jifenBtn.selected) {
            self.footerView.jifenMoney.text = [NSString stringWithFormat:@"-￥%.2f元",jifenprice];
            productAmount -= jifenprice;
        }else
            self.footerView.jifenMoney.text = @"￥0.0";
    }
    
    NSString * str = [NSString stringWithFormat:@"实付金额：￥%.2f",productAmount];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 6)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(6, string.length - 6)];
    self.PriceLabel.attributedText = string;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourse = [[NSMutableArray alloc]init];
    [self createView];

    [self checkorder];
    
    adjustsScrollViewInsets_NO(self.table, self);
    [self.table registerNib:[UINib nibWithNibName:@"OrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderTableViewCell"];
    // Do any additional setup after loading the view.
}
-(void)createView{
    self.table.backgroundColor = UIColorFromRGB(0xf5f5f9);
    
    UIView * header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 202)];
    self.table.tableHeaderView = header;
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"OrderHeaderView" owner:self options:nil] objectAtIndex:0];
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 202);
    [header addSubview:self.headerView];
    
    UIView * footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 425)];
    self.table.tableFooterView = footer;
    self.footerView = [[[NSBundle mainBundle] loadNibNamed:@"OrderFooterView" owner:self options:nil] objectAtIndex:0];
    self.footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 425);
    [footer addSubview:self.footerView];
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(12, 5, 100, 20)];
    label.text = @"商品列表";
    label.textColor = UIColorFromRGB(0x333333);
    label.font = [UIFont systemFontOfSize:16];
    [view addSubview:label];
    
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourse.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 126;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTableViewCell" forIndexPath:indexPath];
    NSDictionary * data = self.dataSourse[indexPath.row];
    NSDictionary * dic = [data safeObjectForKey:@"productInfo"];
    cell.model = [HomeModel mj_objectWithKeyValues:dic];
    cell.CountLabel.text = [NSString stringWithFormat:@"x%@",[data safeObjectForKey:@"quantity"]];
    return cell;
}
- (IBAction)SurePay:(id)sender {
    if (_headerView.addressID == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择收货地址"];
        return;
    }
    if (_headerView.day.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择收货时间"];
        return;
    }
    if (_headerView.payID.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择支付方式"];
        return;
    }
    
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:_headerView.addressID forKey:@"receiverId"];
    [paraDic setObject:self.listArray forKey:@"cartItemParam"];
    [paraDic setObject:_headerView.timeLabel.text forKey:@"receiverDate"];
    [paraDic setObject:_headerView.payID forKey:@"paymentMethodId"];
    [paraDic setObject:@"ios" forKey:@"orderType"];
    if (self.footerView.coumodel.no.length > 0) {
        [paraDic setObject:@[self.footerView.coumodel.no] forKey:@"anHaos"];
    }
    if (self.footerView.RemarkTF.text.length > 0) {
        [paraDic setObject:self.footerView.RemarkTF.text forKey:@"memo"];
    }
    if (self.footerView.giftid.length > 0) {
        [paraDic setObject:self.footerView.giftid forKey:@"giftId"];
    }
    if (self.footerView.jifenBtn.selected) {
        [paraDic setObject:[self.data safeObjectForKey:@"userPoint"] forKey:@"usePoint"];
    }
    
    [NetWorkManager requestWithMethod:POST Url:OrderSave Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSDictionary * data = [responseObject safeObjectForKey:@"data"];
            [weakself paywith:[data safeObjectForKey:@"sn"]];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
-(void)paywith:(NSString *)orderid{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:orderid forKey:@"orderSN"];
    
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
            }else if ([paymentMethonCode isEqualToString:@"cash"]){
                [self cartcount];
                UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                OrderListViewController * order = [sb instantiateViewControllerWithIdentifier:@"OrderListViewController"];
                order.status = @"2";
                [self.navigationController pushViewController:order animated:YES];
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
    request.timeStamp= stamp.intValue;
    request.sign= [dic safeObjectForKey:@"sign"];
    [WXApi sendReq:request];
}
@end
