//
//  CategoryViewController.m
//  dudu
//
//  Created by apple on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CategoryViewController.h"
#import "HomeModel.h"
#import "CategoryModel.h"
#import "CategoryTableViewCell.h"
#import "CateGoryCell.h"
#import "HomeHotProduce.h"
#import "GoodsDetailViewController.h"
#import "AppDelegate.h"
#import "BaseTableBarControllerView.h"
#import "AddOrderViewController.h"

@interface CategoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CategoryViewController
//一级分类
-(void)rootproduce{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [NetWorkManager requestWithMethod:POST Url:GETRootProduce Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSArray * array = [CategoryModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
            CategoryModel * model = array[0];
            NSArray * subProductCategory = model.subProductCategory;
            NSArray * arr = [CategoryModel mj_objectArrayWithKeyValuesArray:subProductCategory];
            self->Num = 0;
            [weakself.dataSourse1 addObjectsFromArray:array];
            [weakself.hotProduce addObjectsFromArray:arr];
            [weakself.table1 reloadData];
            [self produceWith:model.ID];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
//二级分类
-(void)produceWith:(NSNumber *)ID{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:ID forKey:@"id"];
    
    [NetWorkManager requestWithMethod:POST Url:GETProduce Parameters:paraDic success:^(id responseObject) {
        NSArray * array = [HomeModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
        if (array.count == 0) {
            self->tishiView.hidden = NO;
        }else
            self->tishiView.hidden = YES;
        if (self->Page == 0) {
            [weakself.dataSourse2 removeAllObjects];
        }
        [weakself.dataSourse2 addObjectsFromArray:array];
        [weakself.table2 reloadData];
    } requestRrror:^(id requestRrror) {
        
    }];
}
-(void)cartlist{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [NetWorkManager requestWithMethod:POST Url:CartList Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSArray * data = [responseObject safeObjectForKey:@"data"][@"cartItems"];
            self->cartView.array = data;
            self->cartView.dic = [responseObject safeObjectForKey:@"data"];
            [weakself cartcount];
            [weakself checklist:[responseObject safeObjectForKey:@"data"]];
        }
    } requestRrror:^(id requestRrror) {
    }];
}
-(void)checklist:(NSDictionary *)dic{
    NSArray * cartItems = [dic safeObjectForKey:@"cartItems"];
    float money = 0;
    float yajin = 0;
    for (int i =0; i<cartItems.count; i++) {
        NSDictionary * data = cartItems[i];
        NSDictionary * dic = [data safeObjectForKey:@"productInfo"];
        HomeModel * model = [HomeModel mj_objectWithKeyValues:dic];
        NSString * countstr = [NSString stringWithFormat:@"%@",[data safeObjectForKey:@"quantity"]];
        int quantity = [countstr intValue];
        money = money + model.price * quantity;
        yajin = yajin + model.boxPrice * quantity;
    }
//    NSString * boxAmount = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"boxAmount"]];
    NSString * freeFreight = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"freeFreight"]];
    if (money < [freeFreight floatValue]) {
        self.tishiLabel.text = [NSString stringWithFormat:@"还差%.2f元免运费",[freeFreight floatValue] - money];
        self.tishiHeight.constant = 26;
        self.tishi.hidden = NO;
        self.PriceLabel.text = [NSString stringWithFormat:@"另需筐押金%.0f元，运费%@",yajin,[dic safeObjectForKey:@"freight"]];
    }else{
        self.tishiHeight.constant = 0;
        self.tishi.hidden = YES;
        self.PriceLabel.text = [NSString stringWithFormat:@"另需筐押金%.0f元",yajin];
    }
    NSString * minPrice = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"minPrice"]];
    if (money < [minPrice floatValue]) {
        self.SureBtn.backgroundColor = UIColorFromRGB(0xcccccc);
        self.SureBtn.enabled = NO;
    }else{
        self.SureBtn.backgroundColor = UIColorFromRGB(0x20d994);
        self.SureBtn.enabled = YES;
    }
    
    NSString * str = [NSString stringWithFormat:@"合计￥%.2f",money];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 3)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(3, string.length - 3)];
    self.TitleLabel.attributedText = string;
}
//购物车数量
-(void)cartcount{
        WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:[FYUser userInfo].token forKey:@"token"];
    [NetWorkManager requestWithMethod:POST Url:CartCount Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code intValue] == 0) {
            int data = [[responseObject safeObjectForKey:@"data"] intValue];
            if (data > 0) {
                weakself.CountBtn.text = [NSString stringWithFormat:@"%d",data];
                weakself.CountBtn.hidden = NO;
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                BaseTableBarControllerView *tabbar = (BaseTableBarControllerView *)delegate.window.rootViewController;
                [tabbar.tabBar showBadgeOnItemIndex:2 Withnum:data];
            }else
                weakself.CountBtn.hidden = YES;
        }
    } requestRrror:^(id requestRrror) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourse1 = [[NSMutableArray alloc]init];
    self.dataSourse2 = [[NSMutableArray alloc]init];
    self.hotProduce = [[NSMutableArray alloc]init];
    Page = 0;
    [self rootproduce];
    [self cartcount];
    [self cartlist];
    self.CountBtn.layer.cornerRadius = 7.5;
    
    adjustsScrollViewInsets_NO(self.table1, self);
    adjustsScrollViewInsets_NO(self.table2, self);
    
    [self.table2 registerNib:[UINib nibWithNibName:@"CategoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"CategoryTableViewCell"];
    [self.table1 registerNib:[UINib nibWithNibName:@"CateGoryCell" bundle:nil] forCellReuseIdentifier:@"CateGoryCell"];
    
    [self createView];
    self.CountBtn.layer.cornerRadius = 7.5;
    self.SearchView.layer.cornerRadius = 15;
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    cartView = [[[NSBundle mainBundle] loadNibNamed:@"CartView" owner:self options:nil] objectAtIndex:0];
    cartView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 51 - BarBottomHeight);
    cartView.hidden = YES;
    [window addSubview:cartView];
    WS(weakself);
    [cartView setCartBlock:^{
        [weakself cartlist];
    }];
    // Do any additional setup after loading the view.
}
-(void)createView{
    tishiView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 75)/2 - 100, 80, 200, 150)];
    tishiView.hidden = YES;
    [self.table2 addSubview:tishiView];
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(50, 10, 100, 100)];
    image.image = [UIImage imageNamed:@"1"];
    [tishiView addSubview:image];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 135, 180, 15)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UIColorFromRGB(0x666666);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"该分类下暂无相关商品";
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.table1) {
        return 45;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.table1) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 76, 45)];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 25)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorFromRGB(0x333333);
        if (Num == section) {
            label.textColor = UIColorFromRGB(0x20d994);
        }
        CategoryModel * model = self.dataSourse1[section];
        label.text = model.name;
        [view addSubview:label];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 76, 45);
        btn.tag =section;
        [btn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        return view;
    }
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 76, 39)];
    
    return view;
}
-(void)buttonclick:(UIButton *)btn{
    Num = btn.tag;
    Rownum = 0;
    CategoryModel * model = self.dataSourse1[Num];
    NSArray * subProductCategory = model.subProductCategory;
    NSArray * arr = [CategoryModel mj_objectArrayWithKeyValuesArray:subProductCategory];
    [self.hotProduce removeAllObjects];
    [self.hotProduce addObjectsFromArray:arr];
    [self.table1 reloadData];
    [self produceWith:model.ID];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.table1) {
        return self.dataSourse1.count;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.table1) {
        if (section == Num) {
            return self.hotProduce.count;
        }
        return 0;
    }
    return self.dataSourse2.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.table1) {
        return 40;
    }
    return 126;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.table1) {
        CateGoryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CateGoryCell" forIndexPath:indexPath];
        CategoryModel * model = self.hotProduce[indexPath.row];
        cell.titleLabel.text = model.name;
        if (Rownum == 0 || indexPath.row != Rownum - 1) {
            cell.line.hidden = YES;
            cell.titleLabel.textColor = UIColorFromRGB(0x333333);
        }else{
            cell.line.hidden = NO;
            cell.titleLabel.textColor = UIColorFromRGB(0x20d944);
        }
        return cell;
    }
    CategoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryTableViewCell" forIndexPath:indexPath];
    cell.model = self.dataSourse2[indexPath.row];
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
    HomeModel * model = self.dataSourse2[btn.tag];
    if (model.stock == 0) {
        [SVProgressHUD showErrorWithStatus:@"当前商品库存为0"];
        return;
    }
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
    WS(weakself);
    [NetWorkManager requestWithMethod:POST Url:CartAdd Parameters:dic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"加入购物车成功"];
            [self->submitView removeFromSuperview];
            [weakself cartlist];
            [weakself cartcount];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.table1) {
        CategoryModel * model = self.hotProduce[indexPath.row];
        [self.dataSourse2 removeAllObjects];
        [self produceWith:model.ID];
        Rownum = indexPath.row + 1;
        [self.table1 reloadData];
    }else{
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GoodsDetailViewController * detail = [sb instantiateViewControllerWithIdentifier:@"GoodsDetailViewController"];
        HomeModel * model = self.dataSourse2[indexPath.row];
        detail.GoodsID = model.ID;
        [self.navigationController pushViewController:detail animated:YES];
    }
}
- (IBAction)cartClick:(id)sender {
    if ([FYUser userInfo].token.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        return;
    }
    BOOL ishidden = cartView.hidden;
    if (ishidden) {
        [self cartlist];
        ishidden = NO;
        cartView.hidden = NO;
    }else{
        ishidden = YES;
        cartView.hidden = YES;
    }
}
- (IBAction)sure:(id)sender {
//    if (!self.tishi.hidden) {
//        [SVProgressHUD showErrorWithStatus:@"尚未达到起送价"];
//        return;
//    }
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddOrderViewController * addorder = [sb instantiateViewControllerWithIdentifier:@"AddOrderViewController"];
    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in cartView.array) {
        NSDictionary * data = [dic safeObjectForKey:@"productInfo"];
        HomeModel * model = [HomeModel mj_objectWithKeyValues:data];
        NSMutableDictionary * paraDic = @{}.mutableCopy;
        NSMutableDictionary * modeldic = @{}.mutableCopy;
        [modeldic setObject:model.ID forKey:@"id"];
        [paraDic setObject:modeldic forKey:@"productParam"];
        NSString * count = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"quantity"]];
        [paraDic setObject:count forKey:@"quantity"];
        [array addObject:paraDic];
    }
    addorder.listArray = array;
    [self.navigationController pushViewController:addorder animated:YES];
}
@end
