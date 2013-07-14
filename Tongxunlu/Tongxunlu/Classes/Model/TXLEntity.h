//
//  TXLEntity.h
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "EZEntity.h"

@interface TXLEntity : EZEntity

@property(nonatomic,assign)NSInteger status;
@property(nonatomic,strong)EZEntity* entityData;

-(id)initWithDictionary:(NSDictionary *)dict entityClass:(Class)class forKey:(NSString*)key;

@end
