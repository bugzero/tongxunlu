//
//  User.h
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//


#import "EZNavigationController.h"
@interface User : NSObject

typedef void(^UserLoginSuccess)(void);

+(id)instance;

@property(nonatomic,strong)EZNavigationController*  navigationCtl;
@property(nonatomic,copy)UserLoginSuccess   loginSuccess;

-(BOOL)isLogin;

+(void)loginWithAction:(id)aAction selector:(SEL)aSelector;

+(void)loginWithBlock:(UserLoginSuccess)block;

-(void)loginRequest:(NSString *)name pwd:(NSString *)pwd isRemember:(BOOL)rember;

+(void)logout;
@end
