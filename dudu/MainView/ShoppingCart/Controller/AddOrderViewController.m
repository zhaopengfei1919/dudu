//
//  AddOrderViewController.m
//  dudu
//
//  Created by apple on 2018/8/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AddOrderViewController.h"

@interface AddOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AddOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourse = [[NSMutableArray alloc]init];
    [self createView];

    
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
    if (self.dataSourse.count > 0) {
        return 100;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.dataSourse.count > 0) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        view.backgroundColor = [UIColor whiteColor];
        
        return view;
    }
    return nil;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourse.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 126;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    return nil;
}
@end
