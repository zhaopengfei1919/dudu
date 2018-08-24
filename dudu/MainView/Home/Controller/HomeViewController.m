//
//  HomeViewController.m
//  dudu
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HomeViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "CategoryViewController.h"
#import "HomeTableViewCell1.h"
#import "HomeTableViewCell2.h"
#import "HomeTableViewCell3.h"
#import "HomeHotProduce.h"
#import "AppDelegate.h"
#import "BaseTableBarControllerView.h"
#import "PromotionModel.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,homeHeaderViewDelegate>

@end

@implementation HomeViewController
//首页banner列表
-(void)adlist{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"adPositionId"];
    
    [NetWorkManager requestWithMethod:POST Url:AdList Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject objectForKey:@"code"];
        if ([code intValue] == 0) {
            NSLog(@"%@",responseObject);
            NSArray * data = [responseObject safeObjectForKey:@"data"];
            [weakself.bannerList addObjectsFromArray:data];
            NSMutableArray *pic = [NSMutableArray array];
            for (int i = 0; i <self.bannerList.count; i ++) {
                NSDictionary * dic = self.bannerList[i];
                NSString * path = [dic safeObjectForKey:@"path"];
                if (path.length > 0) {
                    [pic addObject:path];
                }
            }
            self->header.imageUrl = pic;
            self->header.Scroll.hidden = NO;
        }else
            self->header.Scroll.hidden = YES;
    } requestRrror:^(id requestRrror) {
        
    }];
}
//首页促销模块
-(void)promotion{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    
    [NetWorkManager requestWithMethod:POST Url:Promotion Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSArray * array = [PromotionModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
            [weakself.promotionSourse addObjectsFromArray:array];
            [weakself.table reloadData];
        }
    } requestRrror:^(id requestRrror) {
        
    }];
}
//首页热卖商品列表
-(void)hotproduce{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    
    [NetWorkManager requestWithMethod:POST Url:HotProduce Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSArray * array = [HomeHotProduce mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
            [weakself.dataSourse addObjectsFromArray:array];
            [weakself.table reloadData];
        }
    } requestRrror:^(id requestRrror) {
        
    }];
}
//购物车数量
-(void)cartcount{
//    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:[FYUser userInfo].token forKey:@"token"];
    [NetWorkManager requestWithMethod:POST Url:CartCount Parameters:paraDic success:^(id responseObject) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        BaseTableBarControllerView *tabbar = (BaseTableBarControllerView *)delegate.window.rootViewController;
        [tabbar.tabBar showBadgeOnItemIndex:2 Withnum:25];
    } requestRrror:^(id requestRrror) {
        
    }];
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if ([FYUser userInfo].token.length > 0) {
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourse = [[NSMutableArray alloc]init];
    self.promotionSourse = [[NSMutableArray alloc]init];
    self.bannerList = [[NSMutableArray alloc]init];
    [self hotproduce];
    [self adlist];
    [self promotion];
    [self cartcount];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpTocategoryController) name:@"pushcategory" object:nil];
    
    adjustsScrollViewInsets_NO(self.table, self);
    [self.table registerNib:[UINib nibWithNibName:@"HomeTableViewCell1" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell1"];
    [self.table registerNib:[UINib nibWithNibName:@"HomeTableViewCell2" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell2"];
    [self.table registerNib:[UINib nibWithNibName:@"HomeTableViewCell3" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell3"];
    
    UIView *baseHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , SCRXFrom6(140))];
    header = [[[NSBundle mainBundle] loadNibNamed:@"HomeHeader" owner:self options:nil] objectAtIndex:0];
    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCRXFrom6(140));
    header.delegate = self;
    [baseHeaderView addSubview:header];
    self.table.tableHeaderView = baseHeaderView;
    // Do any additional setup after loading the view.
}
-(void)homeScrollViewClickWith:(NSInteger)index{
    
}
- (void)jumpTocategoryController{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushcategory" object:nil];
//    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    CategoryViewController * category = [sb instantiateViewControllerWithIdentifier:@"CategoryViewController"];
//    [self.navigationController pushViewController:category animated:YES];
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
    if ((self.promotionSourse.count > 0 && section == 1) || (self.promotionSourse.count == 0 && section == 0)) {
        return 39;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ((self.promotionSourse.count > 0 && section == 1) || (self.promotionSourse.count == 0 && section == 0)) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 39)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 13, SCREEN_WIDTH, 18)];
        label.textColor = UIColorFromRGB(0xf39700);
        label.font = [UIFont systemFontOfSize:18];
        label.text = @"—— 热销商品 ——";
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
        return view;
    }
    return nil;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.promotionSourse.count > 0) {
        return self.dataSourse.count + 1;
    }
    return self.dataSourse.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = section;
    if (self.promotionSourse.count > 0 && section == 0) {
        int number = (int)self.promotionSourse.count;
        return number/3;
    }
    if (self.promotionSourse.count > 0 && section > 0) {
        count = section - 1;
    }
    HomeHotProduce * model = self.dataSourse[count];
    NSArray * products = model.products;
    if ([model.showType isEqualToString:@"1"]) {
        return products.count;
    }
    NSInteger coun = products.count;
//    if (coun % 2 == 1) {
//        return coun/2 + 1;
//    }
    return coun/2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger count = indexPath.section;
    if (self.promotionSourse.count > 0 && indexPath.section == 0) {
        return 240;
    }
    if (self.promotionSourse.count > 0 && indexPath.section > 0) {
        count = count - 1;
    }
    HomeHotProduce * model = self.dataSourse[count];
    if ([model.showType isEqualToString:@"1"]) {
        return 155;
    }
    return 270;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger count = indexPath.section;
    if (self.promotionSourse.count > 0 && indexPath.section == 0) {
        HomeTableViewCell3 * cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell3" forIndexPath:indexPath];
        cell.array = [self.promotionSourse subarrayWithRange:NSMakeRange(indexPath.row * 3, 3)];
        return cell;
    }
    if (self.promotionSourse.count > 0 && indexPath.section > 0) {
        count = indexPath.section - 1;
    }
    HomeHotProduce * model = self.dataSourse[count];
    NSArray * products = model.products;
    NSArray * produceModel = [HomeModel mj_objectArrayWithKeyValuesArray:products];
    if ([model.showType isEqualToString:@"1"]) {
        HomeTableViewCell1 * cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell1" forIndexPath:indexPath];
        cell.model = produceModel[indexPath.row];
        return cell;
    }
    HomeTableViewCell2 * cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell2" forIndexPath:indexPath];
    cell.array = [produceModel subarrayWithRange:NSMakeRange(indexPath.row * 2, 2)];
    return cell;
}
@end
