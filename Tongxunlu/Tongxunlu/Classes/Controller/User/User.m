//
//  User.m
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "User.h"
#import "TXLSetting.h"
#import "AccountEntity.h"
#import "LoginViewController.h"
#import "TXLKeyChainHelper.h"
#import <objc/message.h>

@interface User (){
    UITextField*    _nameTextField;
    UITextField*    _pwdTextField;


}
@property(nonatomic,assign)BOOL bLogin;
@property(nonatomic,retain)LoginViewController*     loginVC;
@property(nonatomic,assign)id action;
@property(nonatomic,assign)SEL  selector;

@end

@implementation User


-(id)init{
    self = [super init];
    if (self) {
        NSString* userName = [TXLKeyChainHelper getUserNameWithService:USER_NAME];
        if (!isEmptyStr(userName)) {
            NSString* pwd = [TXLKeyChainHelper getPasswordWithService:USER_PWD];
            if (!isEmptyStr(pwd)) {
                [self loginRequest:@"test" pwd:@"test" isRemember:YES];
                //[self showNotice:@"我是自动登陆哦" duration:2.0];
            }
        }
    }
    
    return self;
}

+(id)instance
{
    static User *_request = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _request = [[User alloc] init];
    });
    
    return _request;
}

+(void)loginWithAction:(id)aAction selector:(SEL)aSelector{
    if ([[User instance]isLogin]) {
        if ([aAction respondsToSelector:aSelector]) {
//            [aAction performSelector:aSelector];
            objc_msgSend(aAction, aSelector);
        }
    }
    else{
        User* user = [User instance];
        user.action = aAction;
        user.selector = aSelector;
        if (!user.loginVC) {
            user.loginVC = [[LoginViewController alloc]init];
        }

        
        [user.navigationCtl pushViewController:user.loginVC withAnimation:PageTransitionVertical];
        
        
//        [user.ezNavigationController pushViewController:user withAnimation:PageTransitionVertical];
    }
}

+(void)loginWithBlock:(UserLoginSuccess)block{
    if ([[User instance]isLogin]) {
        if (block) {
            block();
        }
    }
    else{
        User* user = [User instance];
        user.action = nil;
        user.selector = nil;
        user.loginSuccess = block;
        if (!user.loginVC) {
            user.loginVC = [[LoginViewController alloc]init];
        }
        
        
        [user.navigationCtl pushViewController:user.loginVC withAnimation:PageTransitionVertical];
        
        
        //        [user.ezNavigationController pushViewController:user withAnimation:PageTransitionVertical];
    }
}

-(BOOL)isLogin{
    return _bLogin;
}

-(void)loginRequest:(NSString *)name pwd:(NSString *)pwd isRemember:(BOOL)rember{
    if (!name || !pwd) {
        return;
    }
    [[EZRequest instance]postDataWithPath:@"/txlmain-manage/mobile/user/mobileLogin.txl" params:@{@"user.account": name,@"user.password":pwd} success:^(NSDictionary *result) {
        AccountEntity* account = [[AccountEntity alloc]initWithDictionary:result isParserArray:YES];
        
        _bLogin = NO;
        
//        1 : 登陆成功
//        2 : 用户名密码不能为空!
//        3 : 用户名不存在 !
//        4 : 密码不正确 !
//        5：账号被冻结 !
//        6：用户没有登陆权限 !
//        7：产品管理员不能用手机登陆 !
//        8：公司管理员不能用手机登陆 !
//        9：您所在的公司已经过期，无法登陆 !
        switch (account.status) {
            case 1:{
                _bLogin = YES;
                
                if ([self.action respondsToSelector:self.selector]) {
//                    [self.action performSelector:self.selector];
                    objc_msgSend(self.action, self.selector);
                }
                
                if (self.loginSuccess) {
                    self.loginSuccess();
                }
                
                //保存用户id
                [DictStoreSupport writeRtMemoryWithKey:@"userId" WithValue:[NSNumber numberWithInt:account.userId]];
                
                if (rember) {
                    /// autologin
                    [TXLKeyChainHelper saveUserName:name userNameService:USER_NAME psaaword:pwd psaawordService:USER_PWD];
                    [TXLKeyChainHelper saveUserName:account.compCode userNameService:USER_COMP_CODE psaaword:[NSString stringWithFormat:@"%d",account.compId] psaawordService:USER_COMP_ID];
                }
                
                [_loginVC back];
                
            }
                break;
            case 2:///用户名密码不能为空
                [self showNotice:@"用户名密码不能为空" duration:2.0];
                break;
            case 3:///用户名不存在
                [self showNotice:@"用户名不存在" duration:2.0];
                break;
            case 4:///密码不正确
                [self showNotice:@"密码不正确" duration:2.0];
                break;
            case 5:///账号被冻结
                [self showNotice:@"账号被冻结" duration:2.0];
                break;
            case 6:///没有登录权限
                [self showNotice:@"没有登录权限" duration:2.0];
                break;
            case 7:///产品管理员不能用手机登录
                [self showNotice:@"产品管理员不能用手机登录" duration:2.0];
                break;
            case 8:///公司管理员不能用手机登录
                [self showNotice:@"公司管理员不能用手机登录" duration:2.0];
                break;
            case 9:///您所在的公司已经过期，无法登录
                [self showNotice:@"您所在的公司已经过期，无法登录" duration:2.0];
                break;
            default:
                break;
        }
//        if (!_bLogin) {
//            [TXLKeyChainHelper deleteWithUserNameService:USER_NAME psaawordService:USER_PWD];
//            [TXLKeyChainHelper deleteWithUserNameService:USER_COMP_CODE  psaawordService:USER_COMP_ID];
//        }
        
    } failure:^(NSError *error) {
        [self showNotice:@"网络连接异常"];
//        DBG(@"%@",error);
    }];
}

+(void)logout{
    User* user = [User instance];
    user.bLogin = NO;
    [TXLKeyChainHelper deleteWithUserNameService:USER_NAME psaawordService:USER_PWD];
    [TXLKeyChainHelper deleteWithUserNameService:USER_COMP_CODE psaawordService:USER_COMP_ID];
    
}
@end
