//
//  DBManager.h
//  Tongxunlu
//
//  Created by kongkong on 13-7-7.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZEntity.h"

@interface DBManager : NSObject

-(EZEntity*)entityForQuery:(NSString*)query;

@end
