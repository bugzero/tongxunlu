//
//  EZrequest.h
//  12306
//
//  Created by kongkong on 13-5-29.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

#define URL_BASE @"http://111.1.45.158"


typedef void(^SuccessBlock)(NSDictionary *result);
typedef void(^FailureBlock)(NSError* error);

@interface EZRequest : NSObject

@property(nonatomic,retain)AFHTTPClient* client;

+(EZRequest*)instance;


- (void)postDataWithPath:(NSString *)path params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;
@end
