//
//  Header.h
//  FanYou
//
//  Created by apple on 2018/6/7.
//  Copyright © 2018年 apple. All rights reserved.
//
#ifdef __OBJC__
#import <UIKit/UIKit.h>

#ifndef Header_h
#define Header_h

#import "Masonry.h"

#define UserID @"UserID"
#define UserInfo @"UserInfo"

//-------------------获取设备大小-------------------------
#define StatusHeight (iPhoneX ? 44 : 20)
#define BarBottomHeight (iPhoneX ? 34 : 0)
//NavBar高度
#define NavigationBar_HEIGHT 44
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//-------------------适配-------------------------
#define SCRXFrom6(x) ([UIScreen mainScreen].bounds.size.width / 375.0f * (x))
#define SCRYFrom6(y) ([UIScreen mainScreen].bounds.size.height / 667.0f * (y))

#define WS(weakself) __weak __typeof(&*self)weakself = self

//---------------------颜色-----------------------------
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define f3f5f7 UIColorFromRGB(0xf3f5f7)


/**iOS 11 automaticallyAdjustsScrollViewInsets的问题*/
#define  adjustsScrollViewInsets_NO(scrollView,vc)\
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
if (@available(iOS 11.0,*))  {\
scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;\
} else {\
self.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \

#define iPhoneX (([[UIScreen mainScreen] bounds].size.height - 812) ? NO : YES)
//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif


//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]
#define IS_IOS10_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//----------------------图片----------------------------

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]

//定义UIImage对象
#define UIImageName(name) [UIImage imageNamed:name]

//定义UIImageView对象
#define ImageView(A) [UIImageView imageViewWithImageName:A];

//建议使用前两种宏定义,性能高于后者
//----------------------图片----------------------------

//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#endif /* Header_h */
#endif
