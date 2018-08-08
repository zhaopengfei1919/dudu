//
//  NSString+MD5Category.m
//  MeishiPlusCommon
//
//  Copyright 2011 View Alloc inc. All rights reserved.
//  Created by Leo Hou on 12-10-15.
//
//

#import "NSString+MD5Category.h"
#import <CommonCrypto/CommonDigest.h> 


@implementation NSString (MD5Category)
- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}
@end


@implementation NSData (MD5Category)
- (NSString*)md5
{
    unsigned char result[16];
    CC_MD5( self.bytes, (CC_LONG)self.length, result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}
@end