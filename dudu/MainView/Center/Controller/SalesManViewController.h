//
//  SalesManViewController.h
//  dudu
//
//  Created by apple on 2018/8/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesManViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *View1;
- (IBAction)edit:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *SalesmanLabel;

@property (weak, nonatomic) IBOutlet UIView *View2;
- (IBAction)saomiao:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *salesLabel;

- (IBAction)sure:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


@property (strong,nonatomic) NSString * code;
@property (strong,nonatomic) NSString * name;

@property (strong,nonatomic) NSDictionary * dic;
@end
