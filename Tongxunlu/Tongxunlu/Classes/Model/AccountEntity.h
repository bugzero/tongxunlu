//
//  AccountEntity.h
//  Tongxunlu
//
//  Created by kongkong on 13-6-11.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "EZEntity.h"

@interface AccountEntity : EZEntity

@property(nonatomic,strong)NSString* compCode;
@property(nonatomic,assign)NSInteger compId;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* phone;
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,strong)NSString* userName;

@property(nonatomic,assign)int count;
@property(nonatomic,assign)int type;
@property(nonatomic,assign)NSTimeInterval time;
@end
