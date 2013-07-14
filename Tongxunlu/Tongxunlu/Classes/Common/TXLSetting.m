//
//  TXLSetting.m
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "TXLSetting.h"

@implementation TXLSetting

-(NSString*)defaultPath{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *preferencePath = [pathArray objectAtIndex:0];
    NSString *savePath = [preferencePath stringByAppendingString:@"/txl/"];
    return savePath;
}

-(NSString*)appPath{
    
    return [[NSBundle mainBundle]resourcePath];
}

-(void)loadSetting:(void (^)(NSString*))status complete:(void(^)(void))complete{
    
    if (status) {
        status(@"加载设置中...");
    }
    
    NSString* basePath = [self defaultPath];
    NSString* appPath = [self appPath];
    
    [EZinstance setInstance:basePath key:K_TXL_BASE_PATH];
    
    NSString* settingPath = [NSString stringWithFormat:@"%@setting.plist",basePath];

    /// 1、加载设置文件
    NSDictionary* setting = nil;
    /// 不存在，第一次加载
    if (![[NSFileManager defaultManager]fileExistsAtPath:settingPath]){
        setting = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/setting.plist",appPath]] ;
        [setting writeToFile:settingPath atomically:YES];
    }
    else{
        setting = [NSDictionary dictionaryWithContentsOfFile:settingPath];
    }
    
    /// 1.1 记录setting
    _setting = [[NSMutableDictionary alloc]initWithDictionary:setting];

    
    /// 2、默认主题
    NSDictionary* theme = [setting objectForKey:@"theme"];
    NSString* defaultTheme = [setting objectForKey:@"defaultTheme"];
    
    
    NSString* themeName = [theme objectForKey:defaultTheme];
    
    if (isEmptyStr(defaultTheme)) {
        themeName =  [theme objectForKey:[theme allKeys][0]]  ;
    }
    else{
        themeName = [theme objectForKey:defaultTheme];
    }
    
    if (themeName) {
        if ([themeName hasPrefix:@"~/"]) {
            defaultTheme = [NSString stringWithFormat:@"%@/%@",appPath,[themeName substringFromIndex:2] ];
        }
        else if([themeName hasPrefix:@"$/"] ){
            defaultTheme = [NSString stringWithFormat:@"%@/%@",basePath,[themeName substringFromIndex:2] ];
        }
        else{
            
        }
    }
    
    [EZinstance setInstance:defaultTheme key:THEME_IMAGE_BASEPATH];
    
    if (complete) {
        complete();        
    }

}

-(id)settingValueKey:(NSString*)key{
    if (_setting) {
        return [_setting objectForKey:key];
    }
    return nil;
}

@end
