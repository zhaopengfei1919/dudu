//
//  BoxListViewController.m
//  dudu
//
//  Created by apple on 2018/9/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BoxListViewController.h"
#import "TuiKuanTableViewCell.h"

@interface BoxListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation BoxListViewController
-(void)boxlist{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:[NSNumber numberWithInteger:page_number] forKey:@"pageNumber"];
    [paraDic setObject:@"10" forKey:@"pageSize"];

    [NetWorkManager requestWithMethod:POST Url:MyReturnBox Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            [weakself.table.mj_footer endRefreshing];
            NSArray * array = [responseObject objectForKey:@"data"][@"list"];
            if (array.count == 0 && self->page_number == 1) {
                self->tishiView.hidden = NO;
            }else
                self->tishiView.hidden = YES;
            [weakself.dataSourse addObjectsFromArray:array];
            
            [weakself.table reloadData];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourse = [[NSMutableArray alloc]init];
    page_number = 1;
    
    [self createView];
    [self refreshUI];
    [self boxlist];
    
    adjustsScrollViewInsets_NO(self.table, self);
    [self.table registerNib:[UINib nibWithNibName:@"TuiKuanTableViewCell" bundle:nil] forCellReuseIdentifier:@"TuiKuanTableViewCell"];
    // Do any additional setup after loading the view.
}
-(void)refreshUI{
        WS(weakself);
        self.table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self->page_number += 1;
            [weakself boxlist];
        }];
}
-(void)createView{
    tishiView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 150)];
    tishiView.hidden = YES;
    [self.view addSubview:tishiView];
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 50, 10, 100, 100)];
    image.image = [UIImage imageNamed:@"1"];
    [tishiView addSubview:image];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 90, 135, 180, 15)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UIColorFromRGB(0x666666);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"暂无相关数据";
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourse.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary * dic = self.dataSourse[section];
    NSArray * items = [dic safeObjectForKey:@"items"];
    return items.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataSourse[indexPath.section];
    NSArray * items = [dic safeObjectForKey:@"items"];
    NSDictionary * dic1 = items[indexPath.row];
    NSArray * array = [dic1 safeObjectForKey:@"boxs"];
    return 61 + 30 * array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TuiKuanTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TuiKuanTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataSourse[indexPath.section];
    NSArray * items = [dic safeObjectForKey:@"items"];
    NSDictionary * dic1 = items[indexPath.row];
    cell.dic = dic1;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    view.backgroundColor = [UIColor whiteColor];
    NSDictionary * data = self.dataSourse[section];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 75, 15, 60, 15)];
    label1.textAlignment = NSTextAlignmentRight;
    NSString * orderStatus = [data safeObjectForKey:@"status"];
    label1.text = [NSString stringWithFormat:@"%@",orderStatus];
    label1.font = [UIFont systemFontOfSize:16];
    if ([orderStatus isEqualToString:@"已退款"]) {
        label1.textColor = UIColorFromRGB(0xf39700);
    }else if ([orderStatus isEqualToString:@"申请中"]){
        label1.textColor = UIColorFromRGB(0x20d994);
    }else{
        label1.textColor = UIColorFromRGB(0x333333);
    }
    [view addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 100, 15)];
    NSString * name = [data safeObjectForKey:@"sn"];
    label2.text = [NSString stringWithFormat:@"退筐订单号：%@",name];
    label2.font = [UIFont systemFontOfSize:15];
    label2.textColor = UIColorFromRGB(0x333333);
    [view addSubview:label2];
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, SCREEN_WIDTH - 100, 12)];
    NSString * time = [data safeObjectForKey:@"createDate"];
    label3.text = [NSString stringWithFormat:@"下单时间：%@",time];
    label3.font = [UIFont systemFontOfSize:12];
    label3.textColor = UIColorFromRGB(0x888888);
    [view addSubview:label3];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    view.backgroundColor = [UIColor clearColor];
    NSDictionary * data = self.dataSourse[section];
    
    UIView * vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    vi.backgroundColor = [UIColor whiteColor];
    [view addSubview:vi];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH - 115, 20)];
    label2.font = [UIFont systemFontOfSize:15];
    label2.textColor = UIColorFromRGB(0xf39700);
    label2.textAlignment = NSTextAlignmentRight;
    NSString * str = [NSString stringWithFormat:@"合计￥%@",[data safeObjectForKey:@"totlePrice"]];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 3)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(3, string.length - 3)];
    label2.attributedText = string;
    [view addSubview:label2];
    
    return view;
}
@end
