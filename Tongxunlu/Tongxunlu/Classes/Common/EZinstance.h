//
//  EZinstance.h
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface EZinstance : NSObject<MFMessageComposeViewControllerDelegate>{
    NSMutableDictionary* _instanceDic;
}

+(EZinstance*)instance;

+(void)setInstance:(id)instanceValue key:(NSString*)key;

+(id)instanceWithKey:(NSString *)key;

+ (void)makeCall:(NSString *)number;

+ (void)sendMessage:(NSString*)phone;
@end
