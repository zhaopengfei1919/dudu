//
//  NSString+MD5Category.h
//  MeishiPlusCommon
//
//  Copyright 2011 View Alloc inc. All rights reserved.
//  Created by Leo Hou on 12-10-15.
//
//

#import <Foundation/Foundation.h>

@interface NSString (MD5Category)

- (NSString *) md5;

@end


@interface NSData (MD5Category)
- (NSString*)md5;
@end