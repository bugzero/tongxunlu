//
//  DeptObject.h
//  Tongxunlu
//
//  Created by 吴英杰 on 13-7-13.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeptObject : NSObject<NSCoding>

@property (strong,nonatomic)NSString      *name;
@property (strong,nonatomic)NSString      *level;
@property (strong,nonatomic)NSString      *deptId;
@property (strong,nonatomic)NSString      *depParentId;
@property (strong,nonatomic)NSMutableArray       *depts;
@end
