//
//  OrderListViewController.m
//  dudu
//
//  Created by apple on 2018/9/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderListTableViewCell.h"
#import "OrderDetailViewController.h"

@interface OrderListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation OrderListViewController
-(void)orderlist{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:self.status forKey:@"status"];
    [paraDic setObject:[NSNumber numberWithInteger:pagenum] forKey:@"pageNumber"];
    [paraDic setObject:@"10" forKey:@"pageSize"];
    
    [NetWorkManager requestWithMethod:POST Url:Orderlist Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            [weakself.table.mj_footer endRefreshing];
            NSArray * data = [responseObject safeObjectForKey:@"data"];
            if (self->pagenum == 1) {
                [weakself.dataSourse removeAllObjects];
                if (data.count == 0) {
                    self->tishiView.hidden = NO;
                }else
                    self->tishiView.hidden = YES;
            }
            [weakself.dataSourse addObjectsFromArray:data];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadtable) name:@"reloadtable" object:nil];
    ;
    pagenum = 1;
    [self orderlist];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PAY_SUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PAY_FAILE" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadtable" object:nil];
}
-(void)reloadtable{
    pagenum = 1;
    [self.table scrollsToTop];
    [self orderlist];
}
- (void)paySuccess:(NSNotification *)notification{
    pagenum = 1;
    [self.table scrollsToTop];
    [self orderlist];
}
- (void)payFaile:(NSNotification *)notification{
    [SVProgressHUD showErrorWithStatus:@"支付失败"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    self.dataSourse = [[NSMutableArray alloc]init];
    [self refreshUI];
    
    int btntag = 0;
    if ([self.status isEqualToString:@"0"]) {
        btntag = 1;
    }else if ([self.status isEqualToString:@"1"]){
        btntag = 2;
    }else if ([self.status isEqualToString:@"2"]){
        btntag = 3;
    }else if ([self.status isEqualToString:@"3"]){
        btntag = 4;
    }else if ([self.status isEqualToString:@"4"]){
        btntag = 5;
    }else if ([self.status isEqualToString:@"5"]){
        btntag = 6;
    }
    UIButton * btn = (UIButton*)[self.view viewWithTag:btntag];
    btn.selected = YES;
    remberBtn = btn;
    self.LingLeft.constant = (SCREEN_WIDTH/6 - 44)/2 + SCREEN_WIDTH/6*(btntag-1);
    
    self.table.estimatedRowHeight = 0;
    self.table.estimatedSectionHeaderHeight = 0;
    self.table.estimatedSectionFooterHeight = 0;
    adjustsScrollViewInsets_NO(self.table, self);
    [self.table registerNib:[UINib nibWithNibName:@"OrderListTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderListTableViewCell"];
    // Do any additional setup after loading the view.
}
-(void)refreshUI{
    WS(weakself);
    self.table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self->pagenum += 1;
        [weakself orderlist];
        
    }];
}
-(void)createView{
    tishiView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 150)];
    tishiView.hidden = YES;
    [self.table addSubview:tishiView];
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 50, 10, 100, 100)];
    image.image = [UIImage imageNamed:@"1"];
    [tishiView addSubview:image];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 90, 135, 180, 15)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UIColorFromRGB(0x666666);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"暂无此类订单";
    [tishiView addSubview:label];
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
    return 242;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListTableViewCell" forIndexPath:indexPath];
    cell.dic = self.dataSourse[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OrderDetailViewController * detail = [sb instantiateViewControllerWithIdentifier:@"OrderDetailViewController"];
    NSDictionary * dic = self.dataSourse[indexPath.row];
    detail.orderid = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"id"]];
    [self.navigationController pushViewController:detail animated:YES];
}
- (IBAction)statusClick:(id)sender {
    UIButton * btn = (UIButton *)sender;
    self.LingLeft.constant = (SCREEN_WIDTH/6 - 44)/2 + SCREEN_WIDTH/6*(btn.tag-1);
    remberBtn.selected = NO;
    btn.selected = YES;
    remberBtn = btn;
    pagenum = 1;
    if (btn.tag == 1) {//all=全部,unpaid=待付款,unshipped=待发货,shipped=配送中,complete=已完成,cancel=已取消
        self.status = @"0";
    }else if (btn.tag == 2){
        self.status = @"1";
    }else if (btn.tag == 3){
        self.status = @"2";
    }else if (btn.tag == 4){
        self.status = @"3";
    }else if (btn.tag == 5){
        self.status = @"4";
    }else if (btn.tag == 6){
        self.status = @"5";
    }
    [self.table scrollsToTop];
    [self orderlist];
}
@end
