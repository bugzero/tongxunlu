//
//  EZrequest.m
//  12306
//
//  Created by kongkong on 13-5-29.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "EZRequest.h"

@implementation EZRequest

-(id)init{
    self = [super init];
    if (self) {
        self.client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:URL_BASE]];
    }
    
    return self;
}

+(EZRequest*)instance
{
    static EZRequest *_request = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _request = [[EZRequest alloc] init];
    });
    
    return _request;
}

-(void)postDataWithPath:(NSString *)path params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    NSString* url = [URL_BASE stringByAppendingString:path];
    
//    NSURLRequest *request = [_client requestWithMethod:@"POST" path:url parameters:params];
    
    //// success block
    void (^responseSuccess)(AFHTTPRequestOperation*, id) = ^(AFHTTPRequestOperation *operation, id responseObject){
        
        /// json序列化，并解析数据
        NSDictionary *responseDictionary = [responseObject objectFromJSONData];
        if (!responseDictionary) {
            responseDictionary = [NSDictionary dictionaryWithObject:responseObject forKey:@"html"];
        }
        
        
        success(responseDictionary);
        
    };
    
    /// failure block
    void (^failureResponse)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error){
        
        failure(error);
    };
    
    [_client postPath:url parameters:params success:responseSuccess failure:failureResponse];
    
//    
//    AFHTTPRequestOperation *operation = [_client HTTPRequestOperationWithRequest:request success: responseSuccess failure:failureResponse ];
//    
//    [_client enqueueHTTPRequestOperation:operation];
}

@end
