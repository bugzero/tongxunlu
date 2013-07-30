////////////////////////////////////////////////////////////////////////////////
/// CORYRIGHT NOTICE
/// Copyright 2013年 keep-keep.com. All rights reserved.
///
/// @系统名称   KK iOS客户端
/// @模块名称   DictStoreSupport
/// @文件名称   DictStoreSupport.h
/// @功能说明   通用数据字典存取管理
///
/// @软件版本   1.0.0.0
/// @开发人员   wuyj
/// @开发时间   2013-05-22
///
/// @修改记录：最初版本
///
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
extern BOOL syncCompData;
extern BOOL syncShareData;
@interface DictStoreSupport : NSObject {
	
	//变量名以po,持久对象,程序退出保存
	NSMutableDictionary		*_poDict;
	
	//Runtime只在单词运行中有效，不作保存的零时变量
    NSMutableDictionary		*_rtDict;
	
	//temp下次运行的时候才能生效的配置
	NSMutableDictionary		*_tempDict;

}
@property (strong, nonatomic)  NSMutableDictionary *poDict;

@property (strong, nonatomic)  NSMutableDictionary *rtDict;

@property (strong, nonatomic)  NSMutableDictionary *tempDict;

#pragma mark -
#pragma mark sharedSingleton methods
/**
 * @brief 获取配置管理类唯一单例
 * @return 配置管理类实例
 */
+ (DictStoreSupport *)sharedManager;

#pragma mark -
#pragma mark configration methods

/**
 * @brief 保存配置管理类各数据结构。程序即将结束时才调用此函数。
 * @desc  保存配置的同时，Css实例会被同步释放。保存后请寻找时机点重新loadCss，保证之后使用正常。
 */
- (void)storeData:(NSString*)fileName;

/**
 * @brief   配置项读取函数
 * @param   -key配置项的key
 * @return  配置项值
 * @desc    根据配置项的key读取配置项的值，一般值为NSString类型，不排除有其他类型的可能性。格式参照IOS plist格式。
 */
+ (id)readRtConfigWithKey:(NSString *)key;
+ (id)readPoConfigWithKey:(NSString *)key;
/**
 * @brief   配置项写入函数
 * @param   -key配置项的key
 * @param   -value配置项的值
 * @desc    根据配置项的key和value存入配置项，一般值为NSString类型，不排除有其他类型的可能性。格式参照IOS plist格式。
 */
+ (void)writeConfigWithKey:(NSString *)key WithValue:(id)value;

/**
 * @brief   临时配置项写入函数
 * @param   -key配置项的key
 * @param   -value配置项的值
 * @desc    功能参考writeConfigWithKey。单次运行时有效的临时配置项写入接口。其取值优先级会高于一切，谨慎使用
 */
+ (void)writeRtMemoryWithKey:(NSString *)key WithValue:(id)value;

/**
 * @brief   临时配置项写入函数
 * @param   -key配置项的key
 * @param   -value配置项的值
 * @desc    功能参考writeConfigWithKey。下次启动才起效果的配置项。谨慎使用
 */
+ (void)writeTempMemoryWithKey:(NSString *)key WithValue:(id)value;

+ (void)removeAllPoConfigCache;

@end
