//
//  AddOrderViewController.m
//  dudu
//
//  Created by apple on 2018/8/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AddOrderViewController.h"
#import "OrderTableViewCell.h"

@interface AddOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AddOrderViewController
-(void)checkorder{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:self.listArray forKey:@"cartItemParamList"];
    
    [NetWorkManager requestWithMethod:POST Url:CheckOrder Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            self.data = [responseObject safeObjectForKey:@"data"];
            NSArray * data = [responseObject safeObjectForKey:@"data"][@"carts"];
            [weakself.dataSourse removeAllObjects];
            [weakself.dataSourse addObjectsFromArray:data];
            [weakself.table reloadData];
            [weakself chewkPrice];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
-(void)chewkPrice{
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
    
    self.footerView.AllPriceLabel.text = [NSString stringWithFormat:@"￥%@",[self.data safeObjectForKey:@"productAmount"]];
    float productAmount = [[NSString stringWithFormat:@"%@",[self.data safeObjectForKey:@"productAmount"]] floatValue];
    
    self.footerView.yajinLabel.text = [NSString stringWithFormat:@"+￥%@",[self.data safeObjectForKey:@"boxAmount"]];
    self.footerView.yunfeiLabel.text = [NSString stringWithFormat:@"+￥%@",[self.data safeObjectForKey:@"freight"]];
    self.footerView.payMoney.text = [NSString stringWithFormat:@"-￥%@",[self.data safeObjectForKey:@"onlineDiscount"]];
    
    NSArray * anHaos = [self.data safeObjectForKey:@"anHaos"];
    if (anHaos.count == 0) {
        self.footerView.couponLabel.text = @"无可用";
        self.footerView.CouponBtn.enabled = NO;
        self.footerView.couponMoney.text = @"￥0";
    }else{
        self.footerView.couponLabel.text = @"点击选择";
        self.footerView.CouponBtn.enabled = YES;
        if (![self.footerView.couponLabel.text isEqualToString:@"点击选择"]) {
            NSInteger amount = self.footerView.coumodel.amount;
            productAmount = productAmount - amount;
            self.footerView.couponMoney.text = [NSString stringWithFormat:@"-￥%ld",amount];
        }else
            self.footerView.couponMoney.text = @"￥0";
    }
    
    NSInteger userPoint = [[NSString stringWithFormat:@"%@",[self.data safeObjectForKey:@"userPoint"]] integerValue];
    if (userPoint == 0) {
        self.footerView.jifenLabel.text = @"无可用";
        self.footerView.jifenBtn.enabled = NO;
        self.footerView.jifenMoney.text = @"￥0";
    }else{
        self.footerView.couponLabel.text = @"点击选择";
        self.footerView.CouponBtn.enabled = YES;
        if (![self.footerView.jifenMoney.text isEqualToString:@"点击选择"]) {
            NSInteger amount = self.footerView.coumodel.amount;
            productAmount = productAmount - amount;
            self.footerView.jifenMoney.text = [NSString stringWithFormat:@"-￥%ld",amount];
        }else
            self.footerView.jifenMoney.text = @"￥0";
    }
    
    NSString * str = [NSString stringWithFormat:@"实付金额：￥%.1f",productAmount];
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
    [paraDic setObject:self.footerView.RemarkTF.text forKey:@"memo"];
    
    
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
            [weakself paywithtyle:data];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
-(void)paywithtyle:(NSDictionary *)dic{
    
}
@end
