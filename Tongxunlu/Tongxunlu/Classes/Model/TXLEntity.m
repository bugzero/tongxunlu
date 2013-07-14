//
//  TXLEntity.m
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "TXLEntity.h"

@interface TXLEntity(){
    NSString*   _entityClass;
    NSString*   _entityKey;
}
@end

@implementation TXLEntity

-(id)initWithDictionary:(NSDictionary *)dict entityClass:(Class)class forKey:(NSString *)key{
    if ((self = [super init])) {
//        _entityClass = class;
        if (class) {
            _entityClass = [[NSString alloc]initWithString:NSStringFromClass(class)];
        }
        if (!isEmptyStr(key)) {
            _entityKey = [[NSString alloc]initWithString:key];
        }
        [self parseValueFromDic:dict isParserArray:YES];
    }
    return self;
}

-(NSDictionary *)entityMapDictionary{
    NSMutableDictionary* mapDic = [[NSMutableDictionary alloc]initWithDictionary:[super entityMapDictionary]];
    
    if (!isEmptyStr(_entityClass)) {
        [mapDic setObject:_entityClass forKey:@"entityData"];
    }

    
    return mapDic;
}

-(NSDictionary *)keyMapDictionary{
    NSMutableDictionary* mapDic = [[NSMutableDictionary alloc]initWithDictionary:[super keyMapDictionary]];
    
    if (!isEmptyStr(_entityKey)) {
        [mapDic setObject:@"entityData" forKey:_entityKey];        
    }

    
    return mapDic;

}
@end
