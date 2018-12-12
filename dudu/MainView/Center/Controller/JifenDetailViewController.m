//
//  JifenDetailViewController.m
//  dudu
//
//  Created by apple on 2018/12/11.
//  Copyright © 2018 apple. All rights reserved.
//

#import "JifenDetailViewController.h"
#import "JifenDetailTableViewCell.h"
#import "JifenModel.h"

@interface JifenDetailViewController ()

@end

@implementation JifenDetailViewController
-(void)userInfo{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:[FYUser userInfo].token forKey:@"token"];
    
    [NetWorkManager requestWithMethod:POST Url:userinfo Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            self->usermodel = [UserModel mj_objectWithKeyValues:[responseObject safeObjectForKey:@"data"]];
            [weakself createheader];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
-(void)jifenList{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:[NSNumber numberWithInteger:page_number] forKey:@"pageNumber"];
    [paraDic setObject:@"10" forKey:@"pageSize"];
    
    [NetWorkManager requestWithMethod:POST Url:JifenDetail Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            [weakself.table.mj_footer endRefreshing];
            NSArray * array = [responseObject objectForKey:@"data"];
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
    [self userInfo];
    [self createView];
    [self refreshUI];
    [self jifenList];
    
    adjustsScrollViewInsets_NO(self.table, self);
    [self.table registerNib:[UINib nibWithNibName:@"JifenDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"JifenDetailTableViewCell"];
    // Do any additional setup after loading the view.
}
-(void)createheader{
    UIView * header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 81)];
    
    UIImageView * images = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 81)];
    images.image = [UIImage imageNamed:@"图层 3"];
    [header addSubview:images];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 90, 16, 180, 18)];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = UIColorFromRGB(0xffffff);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"我的积分%@",usermodel.point];
    [header addSubview:label];
    
    self.table.tableHeaderView = header;
}
-(void)refreshUI{
    WS(weakself);
    self.table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self->page_number += 1;
        [weakself jifenList];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourse.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JifenDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JifenDetailTableViewCell" forIndexPath:indexPath];
    cell.model = self.dataSourse[indexPath.row];
    return cell;
}
@end
