//
//  CallRecordEntity.h
//  Tongxunlu
//
//  Created by kongkong on 13-7-7.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "AccountEntity.h"

@interface CallRecordEntity : AccountEntity

@property(nonatomic,assign)NSTimeInterval   lastcall;
@property(nonatomic,assign)NSInteger        times;
@end
