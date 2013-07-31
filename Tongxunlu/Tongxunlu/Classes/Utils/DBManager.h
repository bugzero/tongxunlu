//
//  DBManager.h
//  Tongxunlu
//
//  Created by kongkong on 13-7-7.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZEntity.h"
#import "FMResultSet.h"
#import "FMDatabase.h"

@interface DBManager : NSObject

-(void)closeDB;

-(FMResultSet*)excuteQuery:(NSString*)sql;

-(void)insertSql:(NSString*)sql;

-(void)excuteQueryWithSqls:(NSArray*)sqls;

-(FMDatabase*)database;
@end
