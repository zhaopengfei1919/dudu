//
//  ShopCartViewController.m
//  dudu
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShopCartViewController.h"
#import "CategoryViewController.h"

@interface ShopCartViewController ()

@end

@implementation ShopCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpTocategoryController) name:@"pushcategory" object:nil];
    // Do any additional setup after loading the view.
}
- (void)jumpTocategoryController{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushcategory" object:nil];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CategoryViewController * category = [sb instantiateViewControllerWithIdentifier:@"CategoryViewController"];
    [self.navigationController pushViewController:category animated:YES];
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

@end
