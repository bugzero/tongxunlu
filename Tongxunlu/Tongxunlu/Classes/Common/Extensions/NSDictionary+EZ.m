//
//  NSDictionary+EZ.m
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "NSDictionary+EZ.h"

@implementation NSDictionary (EZ)

-(BOOL)containKey:(NSString *)key{
    return [[self allKeys]containsObject:key];
}

-(id)safeDataForKey:(NSString *)key{
    if ([self containKey:key]) {
        id value = [self objectForKey:key];
        
        return value;
    }
    
    return nil;
}

@end


@implementation NSMutableDictionary (EZ)

- (void)setSafeObject:(id)anObject forKey:(id)aKey {
    if (anObject) {
        [self setObject:anObject forKey:aKey];
    }
}

@end
