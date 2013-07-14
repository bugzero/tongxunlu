#import "DictStoreSupport.h"
#import "Constant.h"
#import <objc/runtime.h>


@implementation DictStoreSupport

@synthesize	poDict = _poDict;
@synthesize	rtDict = _rtDict;
@synthesize	tempDict = tempDict;

#pragma mark -
#pragma mark sharedSingleton methods

//////////////////////////////////////////////////////////////////////////////////////////////////
//单例函数
static DictStoreSupport	*sharedSingletonManager = nil;

+ (DictStoreSupport *)sharedManager
{
    @synchronized(self) {
        if (sharedSingletonManager == nil) {
            sharedSingletonManager = [[self alloc] init]; // assignment not done here
        }
    }
	
    return sharedSingletonManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedSingletonManager == nil) {
            sharedSingletonManager = [super allocWithZone:zone];
            return sharedSingletonManager;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return sharedSingletonManager;
}

//- (id)retain
//{
//    return sharedSingletonManager;
//}
//
//- (unsigned)retainCount
//{
//    return UINT_MAX;  //denotes an object that cannot be released
//}
//
//- (oneway void)release
//{
//    //do nothing
//}
//
//- (id)autorelease
//{
//    return sharedSingletonManager;
//}

- (id)init
{
    if ((self = [super init])) {
        _rtDict = [[NSMutableDictionary alloc]init];
        _poDict = [self loadData:COMP_USER_CACHE_DATAS];
        if (!_poDict) {
            _poDict = [[NSMutableDictionary alloc]init];
        }
    }
    return self;
}
//单例函数结束
//////////////////////////////////////////////////////////////////////////////////////////////////

- (void)dealloc
{
    _poDict = nil;
    _rtDict = nil;
    _tempDict = nil;
}

+ (id)readRtConfigWithKey:(NSString *)key
{
    if ([DictStoreSupport sharedManager].rtDict != nil) {
        return [[DictStoreSupport sharedManager].rtDict objectForKey:key];
    }
    return nil;
}

+ (id)readPoConfigWithKey:(NSString *)key
{
    if ([DictStoreSupport sharedManager].poDict != nil) {
        return [[DictStoreSupport sharedManager].poDict objectForKey:key];
    }
    return nil;
}

//+ (NSString*)encodeKey:(NSString*)key
//{
//	NSString *tempKey;
//	tempKey = [key stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
//	return tempKey;
//}


+ (void)writeConfigWithKey:(NSString *)key WithValue:(id)value
{
	@try {
        if(value == nil){
            [[DictStoreSupport sharedManager].poDict removeObjectForKey:key];
        }
        else {
            [[DictStoreSupport sharedManager].poDict setObject:value forKey:key];
        }	
	}
	@catch (NSException * e) {
//		TRACELOG(@"%@",[e name]);
//		TRACELOG(@"%@",[e reason]);
	}
	@finally {
	}
}

+ (void)writeRtMemoryWithKey:(NSString *)key WithValue:(id)value
{
	//NSString *tempKey = [self encodeKey:key];
	
	@try {
		[[DictStoreSupport sharedManager].rtDict setObject:value forKey:key];
		//NSLog(@"%@",[[DictStoreSupport sharedManager].rtDict objectForKey:tempKey]) ;
	}
	@catch (NSException * e) {
//		TRACELOG(@"%@",[e name]);
//		TRACELOG(@"%@",[e reason]);
	}
	@finally {
	}
}

+ (void)writeTempMemoryWithKey:(NSString *)key WithValue:(id)value
{
	//NSString *tempKey = [self encodeKey:key];
	
	@try {
		[[DictStoreSupport sharedManager].tempDict setObject:value forKey:key];
	}
	@catch (NSException * e) {
//		TRACELOG(@"%@",[e name]);
//		TRACELOG(@"%@",[e reason]);
	}
	@finally {
	}
}
+ (void)removeAllPoConfigCache
{
    [[DictStoreSupport sharedManager].poDict removeAllObjects];
}

- (void)storeData:(NSString*)fileName
{
    NSMutableDictionary *poDict = [DictStoreSupport sharedManager].poDict;
    if (poDict!=nil) {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
        [poDict writeToFile:path atomically:YES];
    }
}

- (NSMutableDictionary*)loadData:(NSString*)fileName
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];

    return  [[NSMutableDictionary alloc]initWithContentsOfFile:path];
}

@end
