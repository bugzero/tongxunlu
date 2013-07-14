//
//  NSDictionary+EZ.h
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (EZ)

-(BOOL)containKey:(NSString*)key;

-(id)safeDataForKey:(NSString *)key;

@end

@interface NSMutableDictionary (EZ)

- (void)setSafeObject:(id)anObject forKey:(id)aKey;

@end
