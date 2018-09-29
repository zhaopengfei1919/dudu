//
//  pingjiaViewController.m
//  dudu
//
//  Created by apple on 2018/9/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "pingjiaViewController.h"

@interface pingjiaViewController ()

@end

@implementation pingjiaViewController
-(void)checkPingjia{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:self.orderid forKey:@"id"];
    
    [NetWorkManager requestWithMethod:POST Url:OrderComment Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            weakself.data = [responseObject safeObjectForKey:@"data"];
            NSArray * orderItemComments = [weakself.data safeObjectForKey:@"orderItemComments"];
            if (orderItemComments.count == 0) {
                [weakself createview];
            }else
                [weakself createViewwithCompleted];
        }else
            [weakself createview];
    } requestRrror:^(id requestRrror) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkPingjia];
    WS(weakself);
    Start1 = [[RatingBar alloc] initWithFrame:CGRectMake(0,0, 169, 28)];
    Start1.starNumber = 0;//星星数目
    Start1.enable = YES;//星星数目是否可滑动
    Start1.viewColor = [UIColor whiteColor];
    [self.Stat1 addSubview:Start1];
    statNum1 = Start1.starNumber;
    Start1.starNumberBlock = ^(long starnum){
        self->statNum1 = starnum;
        [weakself checkbtn];
    };
    
    Start2 = [[RatingBar alloc] initWithFrame:CGRectMake(0,0, 169, 28)];
    Start2.starNumber = 0;//星星数目
    Start2.enable = YES;//星星数目是否可滑动
    Start2.viewColor = [UIColor whiteColor];
    [self.Stat2 addSubview:Start2];
    statNum2 = Start2.starNumber;
    Start2.starNumberBlock = ^(long starnum){
        self->statNum2 = starnum;
        [weakself checkbtn];
    };
    
    self.RemarkTV.placeholder = @"为了下次更好地为您服务，请留下宝贵的建议意见";
    self.RemarkTV.layer.borderWidth = 0.5;
    self.RemarkTV.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
    self.RemarkTV.layer.cornerRadius = 3;
    self.SureBtn.layer.cornerRadius = 3;
    // Do any additional setup after loading the view.
}
-(void)checkbtn{
    if (statNum1 == 0 || statNum2 == 0) {
    }else{
        BOOL isall = YES;
        for (NSString * str in self.dataSourse) {
            if ([str isEqualToString:@""]) {
                isall = NO;
                break;
            }
        }
        if (isall) {
            self.SureBtn.enabled = YES;
            self.SureBtn.backgroundColor = UIColorFromRGB(0x20d994);
        }
    }
}
-(void)createViewwithCompleted{
    NSString * expressScore = [self.data safeObjectForKey:@"expressScore"];
    Start1.starNumber = [expressScore integerValue];
    NSString * productScore = [self.data safeObjectForKey:@"productScore"];
    Start2.starNumber = [productScore integerValue];
    
    self.RemarkTV.text = [self.data safeObjectForKey:@"comment"];
    self.RemarkTV.editable = NO;
    
    NSArray * orderItemComments = [self.data safeObjectForKey:@"orderItemComments"];
    for (int i = 0; i<orderItemComments.count; i++) {
        NSDictionary * productInfo = orderItemComments[i];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 15 + 30 * i, SCREEN_WIDTH - 75, 15)];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:15];
        label.text = [productInfo safeObjectForKey:@"productName"];
        [self.GoodsScroll addSubview:label];
        
        UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(SCREEN_WIDTH - 60, 8 + 30 * i, 28, 28);
        btn1.tag = i*2 + 2;
        [btn1 setImage:[UIImage imageNamed:@"赞-赞未选中"] forState:0];
        [btn1 setImage:[UIImage imageNamed:@"赞-赞"] forState:UIControlStateSelected];
        [self.GoodsScroll addSubview:btn1];
        
        UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(SCREEN_WIDTH - 30, 8 + 30 * i, 28, 28);
        btn2.tag = i*2+3;
        [btn2 setImage:[UIImage imageNamed:@"赞-差未选中"] forState:0];
        [btn2 setImage:[UIImage imageNamed:@"赞-差选中"] forState:UIControlStateSelected];
        [self.GoodsScroll addSubview:btn2];
        
        NSString * support = [productInfo safeObjectForKey:@"support"];
        if ([support intValue] == 1) {
            btn1.selected = YES;
            btn2.selected = NO;
        }else{
            btn1.selected = NO;
            btn2.selected = YES;
        }
    }
    self.GoodsViewHeight.constant = 165 + 30 * self.goodsArray.count;
    self.MainViewHeight.constant = self.GoodsViewHeight.constant + 250;
    
    self.SureBtn.hidden = YES;
}
-(void)createview{
    self.dataSourse = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.goodsArray.count; i++) {
        NSDictionary * productInfo = self.goodsArray[i][@"productInfo"];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 15 + 30 * i, SCREEN_WIDTH - 75, 15)];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:15];
        label.text = [productInfo safeObjectForKey:@"name"];
        [self.GoodsScroll addSubview:label];
        
        UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(SCREEN_WIDTH - 60, 8 + 30 * i, 28, 28);
        btn1.tag = i*2 + 2;
        [btn1 setImage:[UIImage imageNamed:@"赞-赞未选中"] forState:0];
        [btn1 setImage:[UIImage imageNamed:@"赞-赞"] forState:UIControlStateSelected];
        [btn1 addTarget:self action:@selector(zan:) forControlEvents:UIControlEventTouchUpInside];
        [self.GoodsScroll addSubview:btn1];
        
        UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(SCREEN_WIDTH - 30, 8 + 30 * i, 28, 28);
        btn2.tag = i*2+3;
        [btn2 setImage:[UIImage imageNamed:@"赞-差未选中"] forState:0];
        [btn2 setImage:[UIImage imageNamed:@"赞-差选中"] forState:UIControlStateSelected];
        [btn2 addTarget:self action:@selector(cha:) forControlEvents:UIControlEventTouchUpInside];
        [self.GoodsScroll addSubview:btn2];
        
        [self.dataSourse addObject:@""];
    }
    self.GoodsViewHeight.constant = 165 + 30 * self.goodsArray.count;
    self.MainViewHeight.constant = self.GoodsViewHeight.constant + 300;
}
-(void)zan:(UIButton *)btn{
    [self.dataSourse replaceObjectAtIndex:(btn.tag - 2)/2 withObject:@"1"];
    btn.selected = YES;
    UIButton * btn1 = (UIButton *)[self.view viewWithTag:btn.tag + 1];
    btn1.selected = NO;
    [self checkbtn];
}
-(void)cha:(UIButton *)btn{
    [self.dataSourse replaceObjectAtIndex:(btn.tag - 2)/2 withObject:@"0"];
    btn.selected = YES;
    UIButton * btn1 = (UIButton *)[self.view viewWithTag:btn.tag - 1];
    btn1.selected = NO;
    [self checkbtn];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.RemarkTV resignFirstResponder];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
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

- (IBAction)Sure:(id)sender {
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:self.orderid forKey:@"orderId"];
    [paraDic setObject:[NSNumber numberWithInteger:statNum1] forKey:@"expressScore"];
    [paraDic setObject:[NSNumber numberWithInteger:statNum2] forKey:@"productScore"];
    if (self.RemarkTV.text.length > 0) {
        [paraDic setObject:self.RemarkTV.text forKey:@"comment"];
    }
    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.dataSourse.count; i++) {
        NSDictionary * productInfo = self.goodsArray[i][@"productInfo"];
        NSString * ID = [productInfo safeObjectForKey:@"id"];
        NSMutableDictionary *para = @{}.mutableCopy;
        [para setObject:ID forKey:@"productId"];
        [para setObject:self.dataSourse[i] forKey:@"support"];
        [array addObject:para];
    }
    [paraDic setObject:array forKey:@"orderItemCommentParams"];
    
    [NetWorkManager requestWithMethod:POST Url:OrderSaveComment Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            [weakself.navigationController popViewControllerAnimated:YES];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
@end
