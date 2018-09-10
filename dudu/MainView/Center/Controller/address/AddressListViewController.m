//
//  AddressListViewController.m
//  dudu
//
//  Created by apple on 2018/8/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressTableViewCell.h"
#import "addressModel.h"
#import "AddressEditViewController.h"

@interface AddressListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AddressListViewController
-(void)addresslist{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    
    [NetWorkManager requestWithMethod:POST Url:MyAddress Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSArray * array =[addressModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
            [weakself.dataSourse removeAllObjects];
            [weakself.dataSourse addObjectsFromArray:array];
            [weakself.table reloadData];
        }
    } requestRrror:^(id requestRrror) {
        
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addresslist];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourse = [[NSMutableArray alloc]init];

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 88)];
    self.table.tableFooterView = view;
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, 31, SCREEN_WIDTH - 30, 56);
    [btn setTitle:@"新增地址" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn setBackgroundColor:UIColorFromRGB(0x20d994)];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(addaddress) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    adjustsScrollViewInsets_NO(self.table, self);
    [self.table registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressTableViewCell"];
    // Do any additional setup after loading the view.
}
-(void)addaddress{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddressEditViewController * edit = [sb instantiateViewControllerWithIdentifier:@"AddressEditViewController"];
    edit.isedit = NO;
    [self.navigationController pushViewController:edit animated:YES];
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
    return 81;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell" forIndexPath:indexPath];
    cell.model = self.dataSourse[indexPath.row];
    cell.editBtn.tag = indexPath.row;
    [cell.editBtn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (IBAction)btnclick:(id)sender {
    UIButton * btn = (UIButton *)sender;
    addressModel * model = self.dataSourse[btn.tag];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddressEditViewController * edit = [sb instantiateViewControllerWithIdentifier:@"AddressEditViewController"];
    edit.isedit = YES;
    edit.model = model;
    [self.navigationController pushViewController:edit animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        addressModel * model = self.dataSourse[indexPath.row];
        
        WS(weakself);
        NSMutableDictionary *paraDic = @{}.mutableCopy;
        [paraDic setObject:model.ID forKey:@"id"];
        
        [NetWorkManager requestWithMethod:POST Url:DeleteAddress Parameters:paraDic success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            NSString * code = [responseObject safeObjectForKey:@"code"];
            if ([code isEqualToString:@"0"]) {
                [weakself addresslist];
            }else
                [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
        } requestRrror:^(id requestRrror) {
            
        }];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.ischosen) {
        if (self.chosenadd) {
            addressModel * model = self.dataSourse[indexPath.row];
            self.chosenadd(model);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
@end
