//
//  WebViewController.h
//  dudu
//
//  Created by apple on 2018/9/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewController : UIViewController
//从登录界面present过来
@property (nonatomic, strong) UIView *navView;

@property (nonatomic,strong) WKWebView * web;

@property (nonatomic,strong) NSString * HtmlUrl;
@property (nonatomic,strong) NSString * Titlestr;
@end
