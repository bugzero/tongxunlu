//
//  CallCell.h
//  Tongxunlu
//
//  Created by kongkong on 13-8-1.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountEntity.h"

typedef enum {
    RECORD_COUNT = UITableViewCellStyleSubtitle,
    RECORD_DETAIL = UITableViewCellStyleValue1
}RecordType;

@interface CallCell : UITableViewCell
@property(nonatomic,assign)RecordType type;
@property(nonatomic,strong)AccountEntity* entity;
@property(nonatomic,weak)id delegate;

-(void)reloadDataWithEntity:(AccountEntity*)entity bEnd:(BOOL)bEnd;


-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
@end
