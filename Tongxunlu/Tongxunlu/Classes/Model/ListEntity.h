//
//  ListEntity.h
//  Tongxunlu
//
//  Created by kongkong on 13-7-14.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "TXLEntity.h"

@interface ListEntity : TXLEntity

@property(nonatomic,retain)NSMutableArray*  list;

-(id)initWithDictionary:(NSDictionary *)dict  listClass:(Class)listClass lisKey:(NSString*)key;

@end
