//
//  ListEntity.m
//  Tongxunlu
//
//  Created by kongkong on 13-7-14.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "ListEntity.h"

@interface ListEntity(){
    NSString*   _listKey;
    NSString*   _listClass;
}

@end

@implementation ListEntity

-(id)initWithDictionary:(NSDictionary *)dict  listClass:(Class)listClass lisKey:(NSString*)key{
    if ((self = [super init])) {
        if (!isEmptyStr(key)) {
            _listKey = [[NSString alloc]initWithString:key];
        }
        
        if (listClass) {
            _listClass = [[NSString alloc]initWithString:NSStringFromClass(listClass)];
        }
        
        [self parseValueFromDic:dict isParserArray:YES];
    }
    return self;
}

-(NSDictionary *)entityMapDictionary{
    NSMutableDictionary* mapDic = [[NSMutableDictionary alloc]initWithDictionary:[super entityMapDictionary]];
    
    if (!isEmptyStr(_listClass)) {
        [mapDic setObject:_listClass forKey:@"list"];
    }
    return mapDic;
}


-(NSDictionary *)keyMapDictionary{
    NSMutableDictionary* mapDic = [[NSMutableDictionary alloc]initWithDictionary:[super keyMapDictionary]];
    
    if (!isEmptyStr(_listKey)) {
        [mapDic setObject:@"list" forKey:_listKey];
    }
    
    
    return mapDic;
}

@end
