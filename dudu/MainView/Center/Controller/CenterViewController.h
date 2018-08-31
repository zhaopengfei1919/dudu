//
//  CenterViewController.h
//  dudu
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface CenterViewController : UIViewController{
    UserModel * usermodel;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ScrollTop;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *PhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *JifenLabel;
@property (weak, nonatomic) IBOutlet UILabel *LevelLabel;

@property (weak, nonatomic) IBOutlet UILabel *SalesManLabel;
- (IBAction)ChosenSalesman:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *salesPlace;


- (IBAction)chosenCoupon:(id)sender;
- (IBAction)myaddress:(id)sender;
- (IBAction)myTuikuan:(id)sender;
- (IBAction)myTuikuang:(id)sender;







- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;



@end
