//
//  OrderListViewController.m
//  dudu
//
//  Created by apple on 2018/9/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderListTableViewCell.h"

@interface OrderListViewController ()

@end

@implementation OrderListViewController
-(void)orderlist{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    
    [NetWorkManager requestWithMethod:POST Url:Orderlist Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSArray * data = [responseObject safeObjectForKey:@"data"];
            if (self->pagenum == 0) {
                [weakself.dataSourse removeAllObjects];
                if (data.count == 0) {
                    self->tishiView.hidden = NO;
                }else
                    self->tishiView.hidden = YES;
            }
            [weakself.dataSourse addObjectsFromArray:data];
            [weakself.table reloadData];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self orderlist];
    [self createView];
    self.dataSourse = [[NSMutableArray alloc]init];
    pagenum = 0;
    
    adjustsScrollViewInsets_NO(self.table, self);
    [self.table registerNib:[UINib nibWithNibName:@"OrderListTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderListTableViewCell"];
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
    label.text = @"暂无此类订单";
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
    return 242;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListTableViewCell" forIndexPath:indexPath];
    cell.dic = self.dataSourse[indexPath.row];
    return cell;
}

@end
