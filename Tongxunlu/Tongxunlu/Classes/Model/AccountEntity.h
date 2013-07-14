//
//  AccountEntity.h
//  Tongxunlu
//
//  Created by kongkong on 13-6-11.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "TXLEntity.h"

@interface AccountEntity : TXLEntity

@property(nonatomic,retain)NSString* compCode;
@property(nonatomic,assign)NSInteger compId;
@property(nonatomic,retain)NSString* name;
@property(nonatomic,retain)NSString* phone;
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,retain)NSString* userName;

@end
