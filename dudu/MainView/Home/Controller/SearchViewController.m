//
//  SearchViewController.m
//  dudu
//
//  Created by apple on 2018/9/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SearchViewController.h"
#import "CategoryTableViewCell.h"
#import "GoodsDetailViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
//促销详情
-(void)seacchstr{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:self.SearchTF.text forKey:@"key"];
    [paraDic setObject:[NSNumber numberWithInteger:page_number] forKey:@"pageNumber"];
    [paraDic setObject:@"10" forKey:@"pageSize"];
    
    [NetWorkManager requestWithMethod:POST Url:Search Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSLog(@"%@",responseObject);
            [weakself.table.mj_footer endRefreshing];
            NSArray * data = [responseObject objectForKey:@"data"];
            NSArray * array = [HomeModel mj_objectArrayWithKeyValuesArray:data];
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
    
    adjustsScrollViewInsets_NO(self.table, self);
    [self.table registerNib:[UINib nibWithNibName:@"CategoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"CategoryTableViewCell"];
    
    [self createView];
    [self refreshUI];
    page_number = 1;
    // Do any additional setup after loading the view.
}
-(void)refreshUI{
    WS(weakself);
//    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self->page_number = 0;
//        [weakself addaddress];
//    }];
//    self.table.mj_header.automaticallyChangeAlpha = YES;
//    [self.table.mj_header beginRefreshing];
    self.table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self->page_number += 1;
        [weakself seacchstr];
    }];
}
-(void)createView{
    tishiView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 150)];
    tishiView.hidden = YES;
    [self.table addSubview:tishiView];
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 50, 10, 100, 100)];
    image.image = [UIImage imageNamed:@"3"];
    [tishiView addSubview:image];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 90, 135, 180, 15)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UIColorFromRGB(0x666666);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"暂无您搜索的内容";
    [tishiView addSubview:label];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.SearchTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入搜索内容"];
        return NO;
    }
    [self.dataSourse removeAllObjects];
    [self seacchstr];
    [textField resignFirstResponder];
    return YES;
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
    return 126;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CategoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryTableViewCell" forIndexPath:indexPath];
    cell.model = self.dataSourse[indexPath.row];
    cell.CartBtn.tag = indexPath.row;
    [cell.CartBtn addTarget:self action:@selector(addcart:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)addcart:(UIButton *)btn{
    if ([FYUser userInfo].token.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController * login = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:login animated:YES completion:^{
            
        }];
        return;
    }
    HomeModel * model = self.dataSourse[btn.tag];
    if (model.specificationNumber == 0) {//没有规格，直接加入购物车
        NSMutableDictionary *paraDic = @{}.mutableCopy;
        [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"quantity"];
        NSMutableDictionary * dic = @{}.mutableCopy;
        [dic setObject:model.ID forKey:@"id"];
        [paraDic setObject:dic forKey:@"productParam"];
        
        [self sureaddcart:paraDic];
    }else{//多规格，调用商品详情接口，获取规格信息
        //        WS(weakself);
        NSMutableDictionary *paraDic = @{}.mutableCopy;
        [paraDic setObject:model.ID forKey:@"id"];
        [NetWorkManager requestWithMethod:POST Url:GoodsDetail Parameters:paraDic success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            NSString * code = [responseObject safeObjectForKey:@"code"];
            if ([code isEqualToString:@"0"]) {
                UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
                self->submitView = [[[NSBundle mainBundle] loadNibNamed:@"HZSubmitView" owner:self options:nil] objectAtIndex:0];
                self->submitView.frame = window.bounds;
                [self->submitView createViewWith:[responseObject safeObjectForKey:@"data"]];
                [self->submitView createBigviewWith:[responseObject safeObjectForKey:@"data"]];
                [self->submitView.SureBtn addTarget:self action:@selector(cartadd) forControlEvents:UIControlEventTouchUpInside];
                [window addSubview:self->submitView];
            }else
                [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
        } requestRrror:^(id requestRrror) {
            
        }];
    }
}
-(void)cartadd{
    NSArray * specifications = [submitView.data safeObjectForKey:@"specifications"];
    if (specifications.count == 2) {
        if (submitView.firstID.length == 0 || submitView.secondID.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请选择相应规格"];
            return;
        }
    }else if (specifications.count == 1){
        if (submitView.firstID.length == 0){
            [SVProgressHUD showErrorWithStatus:@"请选择相应规格"];
            return;
        }
    }
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:submitView.CountLabel.text forKey:@"quantity"];
    NSMutableDictionary * dic = @{}.mutableCopy;
    [dic setObject:submitView.GoodsID forKey:@"id"];
    [paraDic setObject:dic forKey:@"productParam"];
    
    [self sureaddcart:paraDic];
}
-(void)sureaddcart:(NSDictionary *)dic{
    [NetWorkManager requestWithMethod:POST Url:CartAdd Parameters:dic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"加入购物车成功"];
            [self->submitView removeFromSuperview];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GoodsDetailViewController * detail = [sb instantiateViewControllerWithIdentifier:@"GoodsDetailViewController"];
    HomeModel * model = self.dataSourse[indexPath.row];
    detail.GoodsID = model.ID;
    [self.navigationController pushViewController:detail animated:YES];
}
@end
