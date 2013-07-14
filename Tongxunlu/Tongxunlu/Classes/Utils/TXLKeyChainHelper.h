#import <Foundation/Foundation.h>

@interface TXLKeyChainHelper : NSObject

/**
 * @brief 以加密方式保存用户名&密码
 * @param userName         用户名
 * @param userNameService  用户保存的key
 * @param psaaword         用户密码
 * @param pwdService       用户密码的key
 */
+ (void) saveUserName:(NSString*)userName 
      userNameService:(NSString*)userNameKey
             psaaword:(NSString*)pwd 
      psaawordService:(NSString*)pwdService;

/**
 * @brief   删除用户名及密码
 * @param   userNameService  用户名key
 * @param   psaawordService  密码key
 */
+ (void) deleteWithUserNameService:(NSString*)userNameService 
                   psaawordService:(NSString*)pwdService;

/**
 * @brief   读取key读取用户名
 * @param   userNameService  用户名的key
 * @return  NSString         解密的用户名
 */
+ (NSString*) getUserNameWithService:(NSString*)userNameService;

/**
 * @brief   根据key读取密码
 * @param   pwdService       密码key
 * @return  解密的密码
 */
+ (NSString*) getPasswordWithService:(NSString*)pwdService;

@end
