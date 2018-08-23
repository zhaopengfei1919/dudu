//
//  HZSubmitView.h
//  DLWebsite
//
//  Created by Apple　 on 16/11/10.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ddbutton.h"

@interface HZSubmitView : UIView{
    int itemStock;//库存
    
    NSString *guigeID;
    NSString *guigeName;
    NSString *yanseID;
    NSString *yanseName;
    int Cartcount;
}
@property (weak, nonatomic) IBOutlet UIView *backView;
- (IBAction)remove:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *MainImage;
@property (weak, nonatomic) IBOutlet UILabel *MainLabel;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *Name1;
@property (weak, nonatomic) IBOutlet UILabel *Name2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Bottom;
@property (weak, nonatomic) IBOutlet UILabel *TishiLabel;
@property (weak, nonatomic) IBOutlet UIButton *SureBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MainViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ColorHeight;
@property (weak, nonatomic) IBOutlet UIView *ColorView;

@property (weak, nonatomic) IBOutlet UIView *SizeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SizeHeight;

@property (weak, nonatomic) IBOutlet DDButton *Jian;
@property (weak, nonatomic) IBOutlet DDButton *Jia;
@property (weak, nonatomic) IBOutlet UILabel *CountLabel;

@property (strong,nonatomic) NSDictionary * data;

@property (strong,nonatomic) NSString * count;
@property (strong,nonatomic) NSString * cartid;
@property (strong,nonatomic) NSString * yanse;
@property (strong,nonatomic) NSString * guige;

-(void)createViewWith:(NSDictionary *)MyData;
-(void)createBigviewWith:(NSDictionary *)data;
@end
