//
//  ShopCartViewController.m
//  dudu
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShopCartViewController.h"
#import "CategoryViewController.h"
#import "HomeModel.h"
#import "ShopCartTableViewCell.h"
#import "AddOrderViewController.h"

@interface ShopCartViewController ()

@end

@implementation ShopCartViewController
-(void)cartlist{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    
    [NetWorkManager requestWithMethod:POST Url:CartList Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSDictionary * dic = [responseObject safeObjectForKey:@"data"];
            self.data = dic;
            NSArray * data = [responseObject safeObjectForKey:@"data"][@"cartItems"];
            [weakself.dataSourse removeAllObjects];
            if (data.count > 0) {
                self->tishiView.hidden = YES;
            }else{
                self->tishiView.hidden = NO;
                self->tishilabel.text = @"您还没有添加商品到购物车呦";
            }
            [weakself.dataSourse addObjectsFromArray:data];
            if (self.listarray.count > 0) {
                NSMutableSet *set1 = [NSMutableSet setWithArray:self.dataSourse];
                NSMutableSet *set2 = [NSMutableSet setWithArray:self.listarray];
                [set1 intersectSet:set2];
                NSArray * arr = [set1 allObjects];
                [self.selectSourse addObjectsFromArray:arr];
            }
            [weakself.table reloadData];
            [weakself checkinallchosen];
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([FYUser userInfo].token.length > 0) {
        [self cartlist];
        tishiView.hidden = YES;
        self.tishi.hidden = NO;
        self.bottomView.hidden = NO;
        self.table.backgroundColor = UIColorFromRGB(0xf5f5f9);
    }else{
        self->tishiView.hidden = NO;
        tishilabel.text = @"您还没有登录呦";
        self.tishi.hidden = YES;
        self.bottomView.hidden = YES;
        self.table.backgroundColor = UIColorFromRGB(0xffffff);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSourse = [[NSMutableArray alloc]init];
    self.selectSourse = [[NSMutableArray alloc]init];
    
    [self createView];
    
    adjustsScrollViewInsets_NO(self.table, self);
    [self.table registerNib:[UINib nibWithNibName:@"ShopCartTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopCartTableViewCell"];
    // Do any additional setup after loading the view.
}
-(void)createView{
    tishiView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 150)];
    tishiView.hidden = YES;
    [self.table addSubview:tishiView];
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 50, 10, 100, 100)];
    image.image = [UIImage imageNamed:@"1"];
    [tishiView addSubview:image];
    
    tishilabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 90, 135, 180, 15)];
    tishilabel.font = [UIFont systemFontOfSize:14];
    tishilabel.textColor = UIColorFromRGB(0x666666);
    tishilabel.textAlignment = NSTextAlignmentCenter;
    [tishiView addSubview:tishilabel];
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
        NSDictionary *data = [self.dataSourse objectAtIndex:indexPath.row];
        NSDictionary * dic = [data safeObjectForKey:@"productInfo"];
        HomeModel * model = [HomeModel mj_objectWithKeyValues:dic];
        
        WS(weakself);
        NSMutableDictionary *paraDic = @{}.mutableCopy;
        NSMutableDictionary * modeldic = @{}.mutableCopy;
        [modeldic setObject:model.ID forKey:@"id"];
        [paraDic setObject:dic forKey:@"productParam"];
        
        [NetWorkManager requestWithMethod:POST Url:CartDelete Parameters:paraDic success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            NSString * code = [responseObject safeObjectForKey:@"code"];
            if ([code isEqualToString:@"0"]) {
                if ([weakself.selectSourse containsObject:data]) {
                    [weakself.selectSourse removeObject:data];
                    [weakself checkinallchosen];
                }
                [weakself cartlist];
                [weakself cartcount];
            }else
                [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
        } requestRrror:^(id requestRrror) {
            
        }];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourse.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 126;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopCartTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCartTableViewCell" forIndexPath:indexPath];
    NSDictionary * data = self.dataSourse[indexPath.row];
    NSDictionary * dic = [data safeObjectForKey:@"productInfo"];
    cell.model = [HomeModel mj_objectWithKeyValues:dic];
    cell.countLabel.text = [NSString stringWithFormat:@"%@",self.dataSourse[indexPath.row][@"quantity"]];
    cell.editBtn.tag = indexPath.row;
    [cell.editBtn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    cell.jian.tag = indexPath.row;
    [cell.jian addTarget:self action:@selector(jian:) forControlEvents:UIControlEventTouchUpInside];
    cell.jia.tag = indexPath.row;
    [cell.jia addTarget:self action:@selector(jia:) forControlEvents:UIControlEventTouchUpInside];
    if ([self.selectSourse containsObject:data]) {
        cell.selectImage.image = [UIImage imageNamed:@"购物车商品选中"];
    }else{
        cell.selectImage.image = [UIImage imageNamed:@"购物车商品未选中"];
    }
    return cell;
}
-(void)jian:(UIButton *)sender{
    UIButton *btn = (UIButton *)sender;
    NSDictionary *data = self.dataSourse[btn.tag];
    if ([self.selectSourse containsObject:data]) {
        [self.selectSourse removeObject:data];
    }
    NSDictionary * dic = [data safeObjectForKey:@"productInfo"];
    HomeModel * model = [HomeModel mj_objectWithKeyValues:dic];
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    NSMutableDictionary * modeldic = @{}.mutableCopy;
    [modeldic setObject:model.ID forKey:@"id"];
    [paraDic setObject:modeldic forKey:@"productParam"];
    NSString * count = [NSString stringWithFormat:@"%@",[data safeObjectForKey:@"quantity"]];
    int quantity = [count intValue];
    if (quantity < 2) {
        [SVProgressHUD showErrorWithStatus:@"已到最小数量"];
        return;
    }
    [paraDic setObject:[NSNumber numberWithInt:-1] forKey:@"quantity"];
    [self changecount:paraDic];
}
-(void)jia:(UIButton *)sender{
    UIButton *btn = (UIButton *)sender;
    NSDictionary *data = self.dataSourse[btn.tag];
    if ([self.selectSourse containsObject:data]) {
        [self.selectSourse removeObject:data];
    }
    NSDictionary * dic = [data safeObjectForKey:@"productInfo"];
    HomeModel * model = [HomeModel mj_objectWithKeyValues:dic];
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    NSMutableDictionary * modeldic = @{}.mutableCopy;
    [modeldic setObject:model.ID forKey:@"id"];
    [paraDic setObject:modeldic forKey:@"productParam"];
    
    NSString * count = [NSString stringWithFormat:@"%@",[data safeObjectForKey:@"quantity"]];
    int quantity = [count intValue];
    quantity += 1;
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"quantity"];
    [self changecount:paraDic];
}
-(void)changecount:(NSDictionary *)dic{
    WS(weakself);
    
    [NetWorkManager requestWithMethod:POST Url:CartChangeCount Parameters:dic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            [weakself cartlist];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
//cell上选择按钮点击事件
- (void)choose:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSDictionary *dic = self.dataSourse[btn.tag];
    
    if ([self.selectSourse containsObject:dic]) {
        [self.selectSourse removeObject:dic];
    }else{
        [self.selectSourse addObject:dic];
    }

    [self checkinallchosen];
    [self.table reloadData];
}
-(void)checkinallchosen{
    if (self.selectSourse.count == self.dataSourse.count) {
        self.allchosenImage.image = [UIImage imageNamed:@"购物车商品选中"];
    }else{
        self.allchosenImage.image = [UIImage imageNamed:@"购物车商品未选中"];
    }
    
    float money = 0;
    float yajin = 0;
    for (int i =0; i<self.selectSourse.count; i++) {
        NSDictionary * data = self.selectSourse[i];
        NSDictionary * dic = [data safeObjectForKey:@"productInfo"];
        HomeModel * model = [HomeModel mj_objectWithKeyValues:dic];
        NSString * countstr = [NSString stringWithFormat:@"%@",[data safeObjectForKey:@"quantity"]];
        int quantity = [countstr intValue];
        money = money + model.price * quantity;
        yajin = yajin + model.boxPrice * quantity;
    }
//    NSString * boxAmount = [NSString stringWithFormat:@"%@",[self.data safeObjectForKey:@"boxAmount"]];
    NSString * freeFreight = [NSString stringWithFormat:@"%@",[self.data safeObjectForKey:@"freeFreight"]];
    if (money < [freeFreight floatValue]) {
        self.tishiLabel.text = [NSString stringWithFormat:@"还差%.2f元免运费",[freeFreight floatValue] - money];
        self.tishiHeight.constant = 26;
        self.tishi.hidden = NO;
        self.yaJinLabel.text = [NSString stringWithFormat:@"另需筐押金%.0f元，运费%@",yajin,[self.data safeObjectForKey:@"freight"]];
    }else{
        self.tishiHeight.constant = 0;
        self.tishi.hidden = YES;
        self.yaJinLabel.text = [NSString stringWithFormat:@"另需筐押金%.0f元",yajin];
    }
    NSString * minPrice = [NSString stringWithFormat:@"%@",[self.data safeObjectForKey:@"minPrice"]];
    if (money < [minPrice floatValue]) {
        self.sureBtn.backgroundColor = UIColorFromRGB(0xcccccc);
        self.sureBtn.enabled = NO;
    }else{
        self.sureBtn.backgroundColor = UIColorFromRGB(0x20d994);
        self.sureBtn.enabled = YES;
    }
    
    NSString * str = [NSString stringWithFormat:@"合计￥%.2f",money];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 3)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(3, string.length - 3)];
    self.PriceLabel.attributedText = string;
}
- (IBAction)allchosen:(id)sender {
    if (self.selectSourse.count < self.dataSourse.count) {
        [self.selectSourse removeAllObjects];
        [self.selectSourse addObjectsFromArray:self.dataSourse];
        self.allchosenImage.image = [UIImage imageNamed:@"购物车商品选中"];
    }else{
        [self.selectSourse removeAllObjects];
        self.allchosenImage.image = [UIImage imageNamed:@"购物车商品未选中"];
    }
    [self checkinallchosen];
    [self.table reloadData];
}
- (IBAction)sure:(id)sender {
//    if (!self.tishi.hidden) {
//        [SVProgressHUD showErrorWithStatus:@"尚未达到起送价"];
//        return;
//    }
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddOrderViewController * addorder = [sb instantiateViewControllerWithIdentifier:@"AddOrderViewController"];
    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in self.selectSourse) {
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
    [self.selectSourse removeAllObjects];
    addorder.listArray = array;
    [self.navigationController pushViewController:addorder animated:YES];
}
@end
