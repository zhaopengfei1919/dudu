//
//  HZCityViewController.m
//  DLWebsite
//
//  Created by Xiaoheng on 15/3/4.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import "HZCityViewController.h"

#import "AddressEditViewController.h"

@interface HZCityViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation HZCityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)area{
    WS(weakself);
    NSMutableDictionary *paraDic = @{}.mutableCopy;
    [paraDic setObject:[NSNumber numberWithInt:792] forKey:@"id"];
    
    [NetWorkManager requestWithMethod:POST Url:areaList Parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = [responseObject safeObjectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            weakself.array = [responseObject safeObjectForKey:@"data"];
            [weakself.table reloadData];
        }
    } requestRrror:^(id requestRrror) {
        
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"区域选择";
    [self area];
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - StatusHeight - BarBottomHeight) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.table];
    [self.table reloadData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *laodMoreCellIdentifierMore1 = @"laodMoreCellIdentifierMore1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:laodMoreCellIdentifierMore1];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:laodMoreCellIdentifierMore1];
    }
    NSDictionary * dic = self.array[indexPath.row];
    cell.textLabel.text = [dic safeObjectForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * dic = self.array[indexPath.row];
    
    NSArray *array = self.navigationController.viewControllers;
    AddressEditViewController *address = [array objectAtIndex:array.count - 2];
    address.area = [dic safeObjectForKey:@"name"];
    address.areaid = [dic safeObjectForKey:@"id"];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
