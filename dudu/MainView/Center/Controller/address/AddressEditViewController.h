//
//  AddressEditViewController.h
//  dudu
//
//  Created by apple on 2018/8/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addressModel.h"

@interface AddressEditViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *NameTF;
@property (weak, nonatomic) IBOutlet UITextField *PhoneTF;
- (IBAction)chosenaddress:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;
@property (weak, nonatomic) IBOutlet UITextField *AreaTF;

- (IBAction)Sure:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *SureBtn;

- (IBAction)deleteaddress:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *provinceid;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *cityid;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *areaid;
@property (assign) BOOL isedit;
@property (strong,nonatomic) addressModel * model;
@end
