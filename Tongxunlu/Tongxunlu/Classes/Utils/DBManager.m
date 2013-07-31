//
//  DBManager.m
//  Tongxunlu
//
//  Created by kongkong on 13-7-7.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "DBManager.h"

#define DB_NAME @"txl.sqlite"
#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }

@interface DBManager(){
    FMDatabase* _db;
}

-(void)openDB;

@end

@implementation DBManager

-(id)init{
    if ((self = [super init])) {
        [self openDB];
        
    }
    return self;
}

#pragma -mark open db
- (BOOL)initDatabase
{
	BOOL success;
	NSError *error;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DB_NAME];
    NSLog(@"%@", writableDBPath);
	success = [fm fileExistsAtPath:writableDBPath];
    
	
	if(!success){
		NSString *defaultDBPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:DB_NAME];
		NSLog(@"%@",defaultDBPath);
		success = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
		if(!success){
			NSLog(@"error: %@", [error localizedDescription]);
		}
		success = YES;
	}
	
	if(success){
		_db = [FMDatabase databaseWithPath:writableDBPath];
		if ([_db open]) {
			[_db setShouldCacheStatements:YES];
		}else{
			NSLog(@"Failed to open database.");
			success = NO;
		}
	}
    
//    [self test];
	
	return success;
}

-(void)openDB{
    
    if (![self initDatabase]) {
        return;
    }
}

-(void)closeDB{
    [_db close];
}

-(void)test{
    NSString* sql = [NSString stringWithFormat:@"INSERT INTO `callrecord`(phone,time,name) VALUES('%@','%ld','%@')",@"15868493753",time(NULL),@"崆崆"];
    [_db executeUpdate:sql];
    
    NSString* query = @"SELECT count(*)  FROM 'callrecord';";
    FMResultSet* set = [_db executeQuery:query];
    
    if ([set next]) {
        NSLog(@"%d", [set intForColumnIndex:0]);
    }
    
    NSLog(@"%@",set);
}

-(FMResultSet*)excuteQuery:(NSString*)sql{
    return [_db executeQuery:sql];
}

-(void)insertSql:(NSString*)sql{
    [_db executeUpdate:sql];
}

-(void)excuteQueryWithSqls:(NSArray *)sqls{
    [_db beginTransaction];
    for (NSString* sql in sqls) {
        if (!isEmptyStr(sql)) {
            [_db executeUpdate:sql];
        }
    }
    [_db commit];
}
@end
