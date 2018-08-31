//
//  GoodsDetailViewController.m
//  dudu
//
//  Created by apple on 2018/8/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "ShopCartViewController.h"

@interface GoodsDetailViewController ()

@end

@implementation GoodsDetailViewController
//根据产品id获取产品具体信息
-(void)goodsdetail{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:self.GoodsID forKey:@"id"];
    [NetWorkManager requestWithMethod:POST Url:GoodsDetail Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            weakself.model = [GoodsModel mj_objectWithKeyValues:[responseObject safeObjectForKey:@"data"]];
            [weakself createUI];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
//购物车数量
-(void)cartcount{
    //    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:[FYUser userInfo].token forKey:@"token"];
    [NetWorkManager requestWithMethod:POST Url:CartCount Parameters:paraDic success:^(id responseObject) {
        int data = [[responseObject safeObjectForKey:@"data"] intValue];
        if (data > 0) {
            self.CountLabel.text = [NSString stringWithFormat:@"%d",data];
            self.CountLabel.hidden = NO;
        }
    } requestRrror:^(id requestRrror) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self goodsdetail];
    [self cartcount];
    self.CountLabel.layer.cornerRadius = 7.5;
    // Do any additional setup after loading the view.
}
-(void)createUI{
    [self.MainImage sd_setImageWithURL:[NSURL URLWithString:self.model.image]];
    self.TitleLabel.text = self.model.name;
    self.contentLabel.text = self.model.memo;
    self.descTextView.text = self.model.introduction;
    GoodsCount = 1;
    self.count.text = [NSString stringWithFormat:@"%d",GoodsCount];
    
    NSString * str = [NSString stringWithFormat:@"￥%.0f",self.model.price];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(1, string.length - 1)];
    self.PriceLabel.attributedText = string;
    
    NSArray * specifications = self.model.specifications;
    float height = 0;
    for (UIView *vi in self.GuiGeView.subviews) {
        if ([vi isKindOfClass:[DDButton class]] || [vi isKindOfClass:[UILabel class]]) {
            [vi removeFromSuperview];
        }
    }
    float buttonwidth = (SCREEN_WIDTH - 60)/3;
    for (int i =0; i < specifications.count; i++) {
        NSDictionary * dic = specifications[i];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(16, 15 + height, 200, 15)];
        label.text = [dic safeObjectForKey:@"name"];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:15];
        [self.GuiGeView addSubview:label];
        NSArray * specificationValues = [dic safeObjectForKey:@"specificationValues"];
        for (int j = 0; j < specificationValues.count; j++) {
            int x = j%3;
            int y = j/3;
            NSDictionary *dic1 = [specificationValues objectAtIndex:j];

            DDButton * button = [DDButton buttonWithType:UIButtonTypeCustom];
            button.dic = dic1;
            button.tag = i;
            button.layer.borderWidth = 0.5;
            button.layer.cornerRadius = 2;
            button.frame = CGRectMake(10 + (buttonwidth + 20) * x, y * 42 +42 + height, buttonwidth, 34);
            [button setTitle:[dic1 safeObjectForKey:@"name"] forState:0];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:UIColorFromRGB(0xcccccc) forState:0];
            [self.GuiGeView addSubview:button];
            
            NSString * strID = [NSString stringWithFormat:@"%@",[dic1 safeObjectForKey:@"id"]];
            if ([_firstID isEqualToString:strID] || [_secondID isEqualToString:strID]) {
                button.layer.borderColor = UIColorFromRGB(0x20d994).CGColor;
                [button setTitleColor:UIColorFromRGB(0x20d994) forState:0];
                
            }else{
                button.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
                [button setTitleColor:UIColorFromRGB(0x333333) forState:0];
            }
            button.userInteractionEnabled = YES;
            [button addTarget:self action:@selector(chosenguige:) forControlEvents:UIControlEventTouchUpInside];
            [self.GuiGeView addSubview:button];
        }
        int x = (int)specificationValues.count%3;
        int y = (int)specificationValues.count/3;
        if (x > 0) {
            y ++ ;
        }
        height += 44 * (y + 1);
    }
    self.GuigeViewHeight.constant = height+50;
    self.MainViewHeight.constant = 600 - 100 + height;
}
-(void)chosenguige:(DDButton *)btn{
    if (btn.tag == 0) {
        self.firstID = [NSString stringWithFormat:@"%@",[btn.dic safeObjectForKey:@"id"]];
    }else
        self.secondID = [NSString stringWithFormat:@"%@",[btn.dic safeObjectForKey:@"id"]];

    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:self.GoodsID forKey:@"productId"];
    NSMutableArray * array = [[NSMutableArray alloc]init];
    if (self.firstID.length > 0) {
        NSArray * specifications = self.model.specifications;
        NSDictionary * dic = specifications[0];
        NSString * ID = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"id"]];
        NSString * str = [NSString stringWithFormat:@"%@:%@",ID,self.firstID];
        [array addObject:str];
    }
    if (self.secondID.length > 0) {
        NSArray * specifications = self.model.specifications;
        NSDictionary * dic = specifications[1];
        NSString * ID = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"id"]];
        NSString * str = [NSString stringWithFormat:@"%@:%@",ID,self.secondID];
        [array addObject:str];
    }
    NSString * str = [array componentsJoinedByString:@","];
    [paraDic setObject:str forKey:@"specParam"];
    
    [NetWorkManager requestWithMethod:POST Url:GetProductDetail Parameters:paraDic success:^(id responseObject) {
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            weakself.model = [GoodsModel mj_objectWithKeyValues:[responseObject safeObjectForKey:@"data"]];
            NSLog(@"%@",_model.ID);
            [weakself createUI];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
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

- (IBAction)AddCart:(id)sender {
    NSArray * specifications = self.model.specifications;
    if (specifications.count == 2) {
        if (self.firstID.length == 0 || self.secondID.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请选择相应规格"];
            return;
        }
    }else if (specifications.count == 1){
        if (self.firstID.length == 0){
            [SVProgressHUD showErrorWithStatus:@"请选择相应规格"];
            return;
        }
    }
    
//    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:[NSNumber numberWithInt:GoodsCount] forKey:@"quantity"];
    NSMutableDictionary * dic = @{}.mutableCopy;
    [dic setObject:self.model.ID forKey:@"id"];//{"productParam":{"id":3},"quantity":10},"
    [paraDic setObject:dic forKey:@"productParam"];
    
    [NetWorkManager requestWithMethod:POST Url:CartAdd Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"加入购物车成功"];
        }else
            [SVProgressHUD showErrorWithStatus:[responseObject safeObjectForKey:@"msg"]];
    } requestRrror:^(id requestRrror) {
        
    }];
}
- (IBAction)jian:(id)sender {
    if (GoodsCount <2) {
        [SVProgressHUD showErrorWithStatus:@"已到最小数量"];
        return;
    }
    GoodsCount -= 1;
    self.count.text = [NSString stringWithFormat:@"%d",GoodsCount];
}

- (IBAction)jia:(id)sender {
    if (GoodsCount >= self.model.stock) {
        [SVProgressHUD showErrorWithStatus:@"已到最大数量"];
        return;
    }
    GoodsCount += 1;
    self.count.text = [NSString stringWithFormat:@"%d",GoodsCount];
}
- (IBAction)gotoCart:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShopCartViewController * detail = [sb instantiateViewControllerWithIdentifier:@"ShopCartViewController"];
    [self.navigationController pushViewController:detail animated:YES];
}
@end