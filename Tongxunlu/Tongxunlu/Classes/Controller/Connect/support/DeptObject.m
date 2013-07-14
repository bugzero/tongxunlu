//
//  DeptObject.m
//  Tongxunlu
//
//  Created by 吴英杰 on 13-7-13.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "DeptObject.h"

@implementation DeptObject
@synthesize name = _name;
@synthesize level   = _level;
@synthesize depParentId    = _depParentId;
@synthesize deptId = _deptId;
@synthesize depts  = _depts;

- (id)init
{
    if(self)
    {
        _depts = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)dealloc
{
    _name = nil;
    _depts = nil;
    _level = nil;
    _depParentId = nil;
    _deptId = nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"kName"];
    [aCoder encodeObject:self.deptId forKey:@"kDeptId"];
    [aCoder encodeObject:self.level forKey:@"kLevel"];
    [aCoder encodeObject:self.depParentId forKey:@"kDepParentId"];
    [aCoder encodeObject:self.depts forKey:@"kDepts"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self =[super init]) {
        self.name = [aDecoder decodeObjectForKey:@"kName"];
        self.deptId = [aDecoder decodeObjectForKey:@"kDeptId"];
        self.level = [aDecoder decodeObjectForKey:@"kLevel"];
        self.depParentId = [aDecoder decodeObjectForKey:@"kDepParentId"];
        self.depts = [aDecoder decodeObjectForKey:@"kDepts"];
    }
    return self;
}
@end
