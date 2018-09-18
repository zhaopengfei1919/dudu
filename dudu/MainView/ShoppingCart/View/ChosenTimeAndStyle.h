//
//  ChosenTimeAndStyle.h
//  dudu
//
//  Created by apple on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^chosentyle)(NSDictionary * dic);

@interface ChosenTimeAndStyle : UIView
@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;


@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UIPickerView *Picker;
- (IBAction)timeSure:(id)sender;
- (IBAction)cancel:(id)sender;






@property (strong,nonatomic) NSString * tyle;
@property (strong,nonatomic) NSArray * array;

@property (nonatomic,copy) chosentyle chosenBlock;
@end
