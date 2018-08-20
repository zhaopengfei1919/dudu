//
//  QRView.m
//  CSHScanDemo
//
//  Created by hh on 15/12/24.
//  Copyright © 2015年 陈胜辉. All rights reserved.
//

#import "QRView.h"
#import "QRScanHeader.h"

@implementation QRView {

        UIImageView *qrLine;
        QRMenu *qrMenu;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    if (!qrLine) {
        //扫描线
        [self initQRLine];
        
    }
    //下方类型切换
//    if (!qrMenu) {
//        [self initQrMenu];
//    }
}

- (void)initQRLine {
    qrLine = [[UIImageView alloc] initWithFrame:CGRectMake(ScanView_X, ScanView_Y, WIDTH-2*ScanView_X, 2)];
    qrLine.image = [UIImage imageNamed:@"line.png"];
    [self addSubview:qrLine];
    upOrdown = NO;
    num = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:ScanView_V target:self selector:@selector(qrLineAnimation) userInfo:nil repeats:YES];
}

-(void)qrLineAnimation
{
    if (upOrdown == NO) {
        num ++;
        qrLine.frame = CGRectMake(ScanView_X, ScanView_Y+num, WIDTH-2*ScanView_X, 2);
        if (num == (SCREEN_WIDTH - 150)) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        qrLine.frame = CGRectMake(ScanView_X, ScanView_Y+num, WIDTH-2*ScanView_X, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}


- (void)initQrMenu {
    
    CGFloat height = 60;
    CGFloat width = self.bounds.size.width;
    qrMenu = [[QRMenu alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - height, width, height)];
    qrMenu.backgroundColor = [UIColor clearColor];
    [self addSubview:qrMenu];
    
    __weak typeof(self)weakSelf = self;

    qrMenu.didSelectedBlock = ^(QRItem *item){
        
        NSLog(@"点击的是%lu",(unsigned long)item.type);
        
        if ([weakSelf.delegate respondsToSelector:@selector(scanTypeConfig:)] ) {
            
            [weakSelf.delegate scanTypeConfig:item];
        }
    };
}

- (void)drawRect:(CGRect)rect {
    
    //整个二维码扫描界面大小
    CGRect screenDrawRect =CGRectMake(0, 0, WIDTH,HEIGHT);
    
    //中间清空的矩形框
    CGRect clearDrawRect = CGRectMake(screenDrawRect.size.width / 2 - self.transparentArea.width / 2,ScanView_Y, self.transparentArea.width,self.transparentArea.height);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //配置扫描外背景颜色
    [self addScreenFillRect:ctx rect:screenDrawRect];
    //配置大小
    [self addCenterClearRect:ctx rect:clearDrawRect];
    //配置四周
    [self addWhiteRect:ctx rect:clearDrawRect];
    //配置四个角
    [self addCornerLineWithContext:ctx rect:clearDrawRect];
    
    
}


- (void)addScreenFillRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextSetRGBFillColor(ctx, 0/255.0, 0/255.0, 0/255.0, 0.2);
    CGContextFillRect(ctx, rect);   //draw the transparent layer
}

- (void)addCenterClearRect :(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextClearRect(ctx, rect);  //clear the center rect  of the layer
}

- (void)addWhiteRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextStrokeRect(ctx, rect);
    //扫描框外框的颜色
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    //扫描框外框的宽度
    CGContextSetLineWidth(ctx, 0.8);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
}

- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect{
    
    //画四个边角
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx, 255 /255.0, 141/255.0, 49/255.0, 1);
    
    //左上角
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x+0.7, rect.origin.y),
        CGPointMake(rect.origin.x+0.7 , rect.origin.y + 15)
    };
    
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y +0.7),CGPointMake(rect.origin.x + 15, rect.origin.y+0.7)};
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    
    //左下角
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x+ 0.7, rect.origin.y + rect.size.height - 15),CGPointMake(rect.origin.x +0.7,rect.origin.y + rect.size.height)};
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x , rect.origin.y + rect.size.height - 0.7) ,CGPointMake(rect.origin.x+0.7 +15, rect.origin.y + rect.size.height - 0.7)};
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    
    //右上角
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - 15, rect.origin.y+0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y +0.7 )};
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width-0.7, rect.origin.y),CGPointMake(rect.origin.x + rect.size.width-0.7,rect.origin.y + 15 +0.7 )};
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    //右下角
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width -0.7 , rect.origin.y+rect.size.height+ -15),CGPointMake(rect.origin.x-0.7 + rect.size.width,rect.origin.y +rect.size.height )};
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - 15 , rect.origin.y + rect.size.height-0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y + rect.size.height - 0.7 )};
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    CGContextStrokePath(ctx);
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}


@end
