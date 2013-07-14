//
//  DBManager.m
//  Tongxunlu
//
//  Created by kongkong on 13-7-7.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"

#define DB_NAME @"txl.db"
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
	//NSLog(@"%@", writableDBPath);
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
	
	return success;
}

-(void)openDB{
    
    if (![self initDatabase]) {
        return;
    }
}

-(EZEntity*)entityForQuery:(NSString*)query{
    FMResultSet* rs = [_db executeQuery:query];
    
    while ([rs next]) {
        
    }
    
    return [[EZEntity alloc]init];
}

@end
