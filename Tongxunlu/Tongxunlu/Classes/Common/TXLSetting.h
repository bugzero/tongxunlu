//
//  TXLSetting.h
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXLSetting : NSObject{
    NSMutableDictionary*    _setting;
}

-(void)loadSetting:(void (^)(NSString*))status complete:(void(^)(void))complete;

-(id)settingValueKey:(NSString*)key;

@end
