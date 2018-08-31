//
//  CouponViewController.m
//  dudu
//
//  Created by apple on 2018/8/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponTableViewCell.h"
#import "CouponModel.h"

@interface CouponViewController ()

@end

@implementation CouponViewController
-(void)coupon{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
//    [paraDic setObject:[FYUser userInfo].token forKey:@"token"];
    [paraDic setObject:[NSNumber numberWithInteger:status] forKey:@"status"];
    
    [NetWorkManager requestWithMethod:POST Url:MyCoupon Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSArray * array = [CouponModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
            if (array.count == 0) {
                self->tishiView.hidden = NO;
            }else
                self->tishiView.hidden = YES;
            [weakself.dataSourse removeAllObjects];
            [weakself.dataSourse addObjectsFromArray:array];
            [weakself.table reloadData];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourse = [[NSMutableArray alloc] init];
    status = 0;
    [self coupon];
    [self createView];
    
    [self.table registerNib:[UINib nibWithNibName:@"CouponTableViewCell" bundle:nil] forCellReuseIdentifier:@"CouponTableViewCell"];
    // Do any additional setup after loading the view.
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
    label.text = @"暂无相关优惠券";
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
    return 115;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CouponTableViewCell" forIndexPath:indexPath];
    cell.model = self.dataSourse[indexPath.row];
    return cell;
}
- (IBAction)btnclick:(id)sender {
    UIButton * btn = (UIButton *)sender;
    if (btn.tag == 1) {
        self.btn1.selected = YES;
        self.btn2.selected = NO;
        status = 0;
    }else{
        self.btn1.selected = NO;
        self.btn2.selected = YES;
        status = 1;
    }
    [self coupon];
}
@end
