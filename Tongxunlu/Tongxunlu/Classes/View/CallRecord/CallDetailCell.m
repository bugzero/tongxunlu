//
//  CallDetailCell.m
//  Tongxunlu
//
//  Created by kongkong on 13-8-2.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "CallDetailCell.h"
#import <QuartzCore/QuartzCore.h>
#import "DBManager.h"
#import "CallDetailView.h"

@interface CallDetailCell(){
    UIView*     _bottomShardow;
}

@end

@implementation CallDetailCell

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
        self.contentView.backgroundColor = RGB(230, 230, 230);
        
        
        CGFloat xOffset = 0,width = FULL_WIDTH/3;
        UIButton* call = [UIButton buttonWithTitle:@"呼叫" image:nil highlightedImage:nil target:self action:@selector(takeCall)];
        call.frame = CGRectMake(xOffset, 0, width, 40);
        [call setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.contentView addSubview:call];
        xOffset += width;
        [self addHSpanView:xOffset];
        
        UIButton* msg = [UIButton buttonWithTitle:@"信息" image:nil highlightedImage:nil target:self action:@selector(takeMessage)];
        msg.frame = CGRectMake(xOffset, 0, width, 40);
        [msg setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.contentView addSubview:msg];
        xOffset += width;
        [self addHSpanView:xOffset];
        
        UIButton* rec = [UIButton buttonWithTitle:@"记录" image:nil highlightedImage:nil target:self action:@selector(takeRecord)];
        rec.frame = CGRectMake(xOffset, 0, width, 40);
        [rec setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.contentView addSubview:rec];
        
        
        /// shardow
        UIView* shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FULL_HEIGHT, 5)];
        [shadowView shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, -3) shadowRadius:2.0f shadowOpacity:0.6];
        [self.contentView addSubview:shadowView];
        
        /// separator
        _bottomShardow = [[UIView alloc]initWithFrame:CGRectMake(0, 40-2, FULL_HEIGHT, 2)];
        [_bottomShardow shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 3) shadowRadius:2.0f shadowOpacity:0.6];
    }
    return self;
}

-(void)addHSpanView:(CGFloat)xOffset{
    UIView* hSep = [[UIView alloc]initWithFrame:CGRectMake(xOffset, 6, 1,28)];
    hSep.backgroundColor = RGB(211, 211, 211);
    [self.contentView addSubview:hSep];
}

-(void)reloadDataWithEntity:(AccountEntity*)entity bEnd:(BOOL)bEnd{
    
    if (bEnd) {
        [_bottomShardow removeFromSuperview];
    }
    else{
        [self.contentView addSubview:_bottomShardow];
    }
    
    self.entity = entity;
}

-(void)takeMessage{
    [EZinstance sendMessage:self.entity.phone];
}

-(void)takeRecord{
    if (isEmptyStr(self.entity.phone)) {
        [self showNotice:@"号码为空"];
        return;
    }
    
    /**
     *	获取数据库记录
     */
    DBManager* db = [EZinstance instanceWithKey:K_DBMANAGER];
    
    NSMutableArray* recordList = [[NSMutableArray alloc]initWithCapacity:1];
    
    if (db) {
        FMResultSet* rs = [db excuteQuery:[NSString stringWithFormat:@"select * from `callrecord` where phone='%@'",self.entity.phone]];
        
        while ([rs next]) {
            AccountEntity* entity = [[AccountEntity alloc]init];
            
            entity.count = [[rs stringForColumnIndex:0]intValue];
            entity.name = [rs stringForColumn:@"name"];
            entity.time = [rs doubleForColumn:@"time"];
            entity.type = RECORD_DETAIL;
            
            entity.phone = [rs stringForColumn:@"phone"];
            
            [recordList addObject:entity];
        }
    }
    
    /**
     *	显示详情
     */
    if (recordList.count > 0) {
        CallDetailView* view = [[CallDetailView alloc]initWithData:recordList];
        
        [view show];
    }
    else{
        [self showNotice:@"没有记录"];
    }

    
}

@end
