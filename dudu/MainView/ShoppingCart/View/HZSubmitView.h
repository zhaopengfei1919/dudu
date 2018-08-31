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
    int GoodsCount;
}
@property (weak, nonatomic) IBOutlet UIView *backView;
- (IBAction)remove:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *MainImage;
@property (weak, nonatomic) IBOutlet UILabel *MainLabel;
@property (weak, nonatomic) IBOutlet UILabel *GuigeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GuigeLabelWidth;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;


@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;

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
@property (strong,nonatomic) NSString * GoodsID;
@property (strong,nonatomic) NSString * firstID;
@property (strong,nonatomic) NSString * secondID;

-(void)createViewWith:(NSDictionary *)MyData;
-(void)createBigviewWith:(NSDictionary *)data;
@end
