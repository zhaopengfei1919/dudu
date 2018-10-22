//
//  BoxViewController.m
//  dudu
//
//  Created by apple on 2018/8/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BoxViewController.h"
#import "TuiKuangTableViewCell.h"
#import "TuiKuangModel.h"

@interface BoxViewController ()

@end

@implementation BoxViewController
-(void)BoxList{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    
    [NetWorkManager requestWithMethod:POST Url:OrderBox Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        [self.table.mj_footer endRefreshing];
        if ([code isEqualToString:@"0"]) {
            [weakself.table.mj_footer endRefreshing];
            NSArray * array = [responseObject objectForKey:@"data"];
            if (array.count == 0 && self->page_number == 1) {
                self->tishiView.hidden = NO;
            }else
                self->tishiView.hidden = YES;
            [weakself.dataSourse addObjectsFromArray:array];
            if (self.dataSourse.count > 0) {
                UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 108)];
                view.backgroundColor = [UIColor whiteColor];
                weakself.table.tableFooterView = view;
                
                weakself.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                weakself.sureBtn.frame = CGRectMake(15, 26, SCREEN_WIDTH - 30, 56);
                weakself.sureBtn.layer.cornerRadius = 3;
                weakself.sureBtn.backgroundColor = UIColorFromRGB(0x20d994);
                weakself.sureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
                [weakself.sureBtn setTitle:@"生成退筐单" forState:0];
                [weakself.sureBtn setTitleColor:[UIColor whiteColor] forState:0];
                [weakself.sureBtn addTarget:self action:@selector(sureadd:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:weakself.sureBtn];
            }
            [weakself.table reloadData];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
-(void)sureadd:(UIButton *)btn{
    WS(weakself);
    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (int i =0; i<self.selectArray.count; i++) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithDictionary:self.selectArray[i]];
        NSInteger tag = [[NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"tag"]] integerValue];
        UILabel * label = (UILabel *)[self.view viewWithTag:tag-5];
        [dic setObject:label.text forKey:@"quantity"];
        [dic removeObjectForKey:@"tag"];
        [array addObject:dic];
    }
    NSLog(@"%@",array);

    [NetWorkManager requestWithMethod:POST Url:ReturnBox Parameters:array success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"退筐成功！"];
            [weakself.navigationController popViewControllerAnimated:YES];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {

    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourse = [[NSMutableArray alloc]init];
    self.selectArray = [[NSMutableArray alloc]init];
    self.changeArray = [[NSMutableArray alloc]init];
    page_number = 1;
    [self BoxList];
    
    [self createView];
    adjustsScrollViewInsets_NO(self.table, self);
    [self.table registerNib:[UINib nibWithNibName:@"TuiKuangTableViewCell" bundle:nil] forCellReuseIdentifier:@"TuiKuangTableViewCell"];
    // Do any additional setup after loading the view.
}
-(void)refreshUI{
    WS(weakself);
    self.table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self->page_number += 1;
        [weakself BoxList];
    }];
}
-(void)createView{
    tishiView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 150)];
    tishiView.hidden = YES;
    [self.view addSubview:tishiView];
    
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
    NSDictionary * dic = self.dataSourse[indexPath.row];
    NSArray * array = [dic safeObjectForKey:@"boxs"];
    return 122 + 30 * array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //因为有变化数量的关系，放弃自定义cell，使cell不复用
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", [indexPath section], [indexPath row]];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dic = self.dataSourse[indexPath.row];
    NSArray * array = [dic safeObjectForKey:@"boxs"];
    
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(11, 16, SCREEN_WIDTH - 100, 15)];
    NSString * name = [dic safeObjectForKey:@"orderId"];
    label2.text = [NSString stringWithFormat:@"订单号：%@",name];
    label2.font = [UIFont systemFontOfSize:15];
    label2.textColor = UIColorFromRGB(0x333333);
    [cell.contentView addSubview:label2];
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(11, 37, SCREEN_WIDTH - 100, 12)];
    NSString * time = [dic safeObjectForKey:@"orderDate"];
    label3.text = [NSString stringWithFormat:@"下单时间：%@",time];
    label3.font = [UIFont systemFontOfSize:12];
    label3.textColor = UIColorFromRGB(0x888888);
    [cell.contentView addSubview:label3];
    
    UIScrollView * scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 58, SCREEN_WIDTH, 30 * array.count)];
    [cell.contentView addSubview:scroll];

    for (int i = 0; i<array.count; i++) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 30 * i, SCREEN_WIDTH, 30)];
        view.backgroundColor = [UIColor whiteColor];
        NSDictionary * data = array[i];
        
        NSMutableDictionary * MainDic = [[NSMutableDictionary alloc]init];
        [MainDic setObject:[dic safeObjectForKey:@"orderSn"] forKey:@"orderSn"];
        [MainDic setObject:[data safeObjectForKey:@"boxId"] forKey:@"boxId"];
        
        DDButton * btn1 = [DDButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(SCREEN_WIDTH - 36, 12, 21, 21);
        [btn1 setImage:[UIImage imageNamed:@"+"] forState:0];
        btn1.dic = data;
        btn1.tag = (indexPath.row + 1) * 20+i;
        [btn1 addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn1];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 15, 34, 16)];
        label.tag = (indexPath.row + 1) * 20+i + 5;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGB(0x20d944);
        label.font = [UIFont systemFontOfSize:15];
        if (self.changeArray.count == 0) {
            label.text = [NSString stringWithFormat:@"%@",[data safeObjectForKey:@"quantity"]];
        }else{
            for (UILabel * lab in self.changeArray) {
                if (lab.tag == label.tag) {
                    label.text = lab.text;
                    break;
                }else
                    label.text = [NSString stringWithFormat:@"%@",[data safeObjectForKey:@"quantity"]];
            }
        }
        [view addSubview:label];
        
        DDButton * btn2 = [DDButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(SCREEN_WIDTH - 96, 12, 21, 21);
        [btn2 setImage:[UIImage imageNamed:@"_"] forState:0];
        btn2.dic = data;
        btn2.tag = (indexPath.row + 1) * 20+i;
        [btn2 addTarget:self action:@selector(jian:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn2];
        
        UILabel * countlabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, 15, 50, 16)];
        countlabel.textColor = UIColorFromRGB(0x666666);
        countlabel.font = [UIFont systemFontOfSize:15];
        countlabel.textAlignment = NSTextAlignmentRight;
        countlabel.text = [NSString stringWithFormat:@"x%@",[data safeObjectForKey:@"quantity"]];
        [view addSubview:countlabel];
        
        DDButton * btn = [DDButton buttonWithType:UIButtonTypeCustom];
        btn.tag = (indexPath.row + 1) * 20+i + 10;
        [MainDic setObject:[NSNumber numberWithInteger:btn.tag] forKey:@"tag"];
        btn.dic = MainDic;
        btn.frame = CGRectMake(5, 4, 22, 22);
        [btn setImage:[UIImage imageNamed:@"购物车商品未选中"] forState:0];
        [btn setImage:[UIImage imageNamed:@"购物车商品选中"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(chosenkuang:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        for (NSDictionary * dic in self.selectArray) {
            if ([dic isEqualToDictionary:btn.dic]) {
                btn.selected = YES;
                break;
            }else
                btn.selected = NO;
        }
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(34, 7.5, SCREEN_WIDTH - 186, 15)];
        title.textColor = UIColorFromRGB(0x333333);
        title.font = [UIFont systemFontOfSize:15];
        title.text = [data safeObjectForKey:@"boxName"];
        CGSize size = [[FYUser userInfo] sizeForString:title.text withFontSize:15 withWidth:100];
        title.frame = CGRectMake(34, 7.5, size.width + 2, 15);
        [view addSubview:title];
        
        UILabel * pricelabel = [[UILabel alloc]initWithFrame:CGRectMake(50 + size.width, 7.5, 70, 15)];
        pricelabel.textColor = UIColorFromRGB(0x333333);
        pricelabel.font = [UIFont systemFontOfSize:12];
        pricelabel.text = [NSString stringWithFormat:@"￥%@/个",[data safeObjectForKey:@"boxPrice"]];
        [view addSubview:pricelabel];
        
        [scroll addSubview:view];
    }
    return cell;
}
-(void)chosenkuang:(DDButton *)btn{
//    if (self.selectArray.count == 0) {
//        [self.selectArray addObject:btn.dic];
//        btn.selected = YES;
//    }else{
//        NSMutableArray * array = [[NSMutableArray alloc]init];
//        [array addObjectsFromArray:self.selectArray];
//
//        for (NSDictionary * dic in self.selectArray) {
//            if ([btn.dic isEqualToDictionary:dic]) {
//                btn.selected = NO;
//                [array removeObject:dic];
//            }else{
//                btn.selected = YES;
//            }
//        }
//        if (array.count == self.selectArray.count) {
//            [self.selectArray addObject:btn.dic];
//            btn.selected = YES;
//        }else{
//            [self.selectArray removeAllObjects];
//            [self.selectArray addObjectsFromArray:array];
//            btn.selected = NO;
//        }
//    }
    if ([self.selectArray containsObject:btn.dic]) {
        [self.selectArray removeObject:btn.dic];
        btn.selected = NO;
    }else{
        [self.selectArray addObject:btn.dic];
        btn.selected = YES;
    }
    NSLog(@"%@",self.selectArray);
}
-(void)add:(DDButton *)btn{
    NSDictionary * data = btn.dic;
    TuiKuangModel * model = [TuiKuangModel mj_objectWithKeyValues:data];
    UILabel * label = (UILabel *)[self.view viewWithTag:btn.tag+5];
    NSInteger count = [label.text integerValue];

    if (count >= model.quantity) {
        [SVProgressHUD showErrorWithStatus:@"已到最大数量"];
        return;
    }
    for (UILabel * lab in self.changeArray) {
        if (lab.tag == label.tag) {
            [self.changeArray removeObject:lab];
            break;
        }
    }
    count ++;
    label.text = [NSString stringWithFormat:@"%ld",count];
    [self.changeArray addObject:label];
}
-(void)jian:(DDButton *)btn{
    UILabel * label = (UILabel *)[self.view viewWithTag:btn.tag+5];
    NSInteger count = [label.text integerValue];
    if (count == 1) {
        [SVProgressHUD showErrorWithStatus:@"已到最小数量"];
        return;
    }
    for (UILabel * lab in self.changeArray) {
        if (lab.tag == label.tag) {
            [self.changeArray removeObject:lab];
            break;
        }
    }
    count -= 1;
    label.text = [NSString stringWithFormat:@"%ld",count];
    [self.changeArray addObject:label];
}
@end
