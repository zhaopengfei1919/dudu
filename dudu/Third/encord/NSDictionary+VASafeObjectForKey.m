//
//  NSDictionary+VASafeObjectForKey.m
//  MeishiPlusCommon
//
//  Copyright 2011 View Alloc inc. All rights reserved.
//  Created by Leo Hou on 12-10-12.
//
//

#import "NSDictionary+VASafeObjectForKey.h"

@implementation NSDictionary (VASafeObjectForKey)

-(id)safeObjectForKey:(NSString*) key
{
    
    id object = [self objectForKey:key];
    
    if ([object isKindOfClass:[NSNull class]]) {
        object = nil;
    }
    
    return object;
}


-(NSMutableDictionary *)mutableDeepCopy{
    NSMutableDictionary *copyDict = [[NSMutableDictionary alloc]initWithCapacity:self.count];
    
    for (id key in self.allKeys) {
        id oneCopy = nil;
        id oneValue = [self valueForKey:key];
        
        if ([oneValue respondsToSelector:@selector(mutableDeepCopy)]) {
            oneCopy = [oneValue mutableDeepCopy];
            //        }else if ([object respondsToSelector:@selector(mutableCopy)]){
            //            oneCopy = [object mutableCopy];
        }else if ([oneValue respondsToSelector:@selector(copy)]){
            oneCopy = [oneValue copy];
        }
        
        [copyDict setValue:oneCopy forKey:key];
    }
    
    return copyDict;
}

@end
