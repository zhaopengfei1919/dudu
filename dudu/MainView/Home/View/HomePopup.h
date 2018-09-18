//
//  HomePopup.h
//  dudu
//
//  Created by apple on 2018/9/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePopup : UIView

@property (weak, nonatomic) IBOutlet UIImageView *images;

@property (weak, nonatomic) IBOutlet UIButton *clickBtn;


- (IBAction)removeView:(id)sender;
@end
