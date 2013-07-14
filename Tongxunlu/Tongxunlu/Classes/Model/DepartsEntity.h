//
//  DepartsEntity.h
//  Tongxunlu
//
//  Created by kongkong on 13-7-14.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "EZEntity.h"

@interface DepartsEntity : EZEntity

@property(nonatomic,assign)NSInteger    depId;
@property(nonatomic,strong)NSString*    depName;
@property(nonatomic,assign)NSInteger    depParentId;

@end
