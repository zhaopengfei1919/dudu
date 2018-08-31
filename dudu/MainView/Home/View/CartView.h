//
//  CartView.h
//  dudu
//
//  Created by apple on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^changeCart)(void);

@interface CartView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MainViewHeight;

- (IBAction)deleteAll:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet UILabel *Count;
@property (weak, nonatomic) IBOutlet UILabel *Price;

@property (strong,nonatomic) NSArray * array;
@property (nonatomic,copy) changeCart CartBlock;
@end
