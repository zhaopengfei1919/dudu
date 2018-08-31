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

@interface ShopCartViewController ()

@end

@implementation ShopCartViewController
-(void)cartlist{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    
    [NetWorkManager requestWithMethod:POST Url:CartList Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSArray * data = [responseObject safeObjectForKey:@"data"];
            [weakself.dataSourse removeAllObjects];
            [weakself.dataSourse addObjectsFromArray:data];
            [weakself.table reloadData];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self cartlist];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSourse = [[NSMutableArray alloc]init];
    self.selectSourse = [[NSMutableArray alloc]init];
    
    [self.table registerNib:[UINib nibWithNibName:@"ShopCartTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopCartTableViewCell"];
    // Do any additional setup after loading the view.
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
                [weakself cartlist];
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
    float money = 0;
    for (int i =0; i<self.selectSourse.count; i++) {
        NSDictionary * data = self.selectSourse[i];
        NSDictionary * dic = [data safeObjectForKey:@"productInfo"];
        HomeModel * model = [HomeModel mj_objectWithKeyValues:dic];
        money += model.price;
    }
    if (money < 99) {
        self.tishiLabel.text = [NSString stringWithFormat:@"还差%.2f元起送",99 - money];
        self.tishiHeight.constant = 26;
        self.tishi.hidden = NO;
    }else{
        self.tishiHeight.constant = 0;
        self.tishi.hidden = YES;
    }
    
    NSString * str = [NSString stringWithFormat:@"合计￥%.0f",money];
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
}
@end
