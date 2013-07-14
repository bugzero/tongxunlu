//
//  EZinstance.m
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "EZinstance.h"
#import <objc/runtime.h>

@interface EZinstance()
@property(nonatomic,retain)NSMutableDictionary* instanceDic;
@end

@implementation EZinstance

#pragma -mark
#pragma -mark 单例对象
+(EZinstance*)instance{
    static EZinstance *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[EZinstance alloc] init];
        
        _instance.instanceDic = [[NSMutableDictionary alloc]initWithCapacity:1];
        
    });
    return _instance;
}

#pragma -mark
#pragma -mark public method
+(id)instanceWithKey:(NSString *)key{
    EZinstance* instance = [EZinstance instance];
    
    if ([instance.instanceDic containKey:key]) {
        return [instance.instanceDic objectForKey:key];
    }
    
    return nil;
}

+(void)setInstance:(id)instanceValue key:(NSString*)key{
    
    if (!instanceValue || !key || [key.trim isEqualToString:@""]) {
        return;
    }
    
    EZinstance* instance = [EZinstance instance];
    
    [instance.instanceDic setSafeObject: instanceValue forKey:key];
}

@end
