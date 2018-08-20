//
//  QRItem.m
//  CSHScanDemo
//
//  Created by hh on 15/12/24.
//  Copyright © 2015年 陈胜辉. All rights reserved.
//

#import "QRItem.h"
#import <objc/runtime.h>

@implementation QRItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
                       titile:(NSString *)titile{
    
    self =  [QRItem buttonWithType:UIButtonTypeSystem];
    if (self) {
        
        [self setTitle:titile forState:UIControlStateNormal];
        self.frame = frame;
    }
    return self;
}
@end
