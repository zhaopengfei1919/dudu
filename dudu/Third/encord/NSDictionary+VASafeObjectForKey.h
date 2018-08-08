//
//  NSDictionary+VASafeObjectForKey.h
//  MeishiPlusCommon
//
//  Copyright 2011 View Alloc inc. All rights reserved.
//  Created by Leo Hou on 12-10-12.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (VASafeObjectForKey)
-(id)safeObjectForKey:(NSString*) key;
-(NSMutableDictionary *)mutableDeepCopy;
@end
