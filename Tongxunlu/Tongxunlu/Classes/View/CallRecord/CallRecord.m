//
//  CallRecord.m
//  Tongxunlu
//
//  Created by kongkong on 13-7-7.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "CallRecord.h"
#import "AccountEntity.h"
#import "FMDatabase.h"
#import "DBManager.h"

@interface CallRecord(){
    NSMutableArray*     _recordData;
    NSString*           _callNumber;
}

@end

@implementation CallRecord

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma -mark 
#pragma -mark UITableViewDataSource & UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_recordData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identify = @"recordCellIdentify";
    
    UITableViewCell*    cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    AccountEntity* account = nil;
    if ([indexPath row] < [_recordData count]) {
        account = _recordData[[indexPath row]];
        if (![account isKindOfClass:[AccountEntity class]]) {
            account = nil;
        }
    }
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (cell && account) {
        cell.textLabel.text = account.name;
        cell.detailTextLabel.text = account.phone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountEntity* account = nil;
    if ([indexPath row] < [_recordData count]) {
        account = _recordData[[indexPath row]];
        if (![account isKindOfClass:[AccountEntity class]]) {
            account = nil;
        }
    }
    
    if (account) {
        
        _callNumber = [[NSString alloc]initWithString:account.phone];
        
        NSString* message = [NSString stringWithFormat:@"是否拨打 号码:%@",account.phone];
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"拨号" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (1 == buttonIndex && !isEmptyStr(_callNumber)) {
        [EZinstance makeCall:_callNumber];
    }
    _callNumber = @"";
}

-(void)reloadData{
    
    if (!_recordData) {
        _recordData = [[NSMutableArray alloc]initWithCapacity:1];
    }
    
    DBManager* db = [EZinstance instanceWithKey:K_DBMANAGER];
    
    if (db) {
        FMResultSet* rs =[db excuteQuery:@"select DISTINCT name, phone  from `callrecord`"];
        while ([rs next]) {
            AccountEntity* entity = [[AccountEntity alloc]init];
            
            NSString* name = [rs stringForColumn:@"name"];
            
            FMResultSet* prs = [db excuteQuery:[NSString stringWithFormat:@"select count(*) from `callrecord` where name='%@'",name]];
            
            if ([prs next]) {
                entity.name = [NSString stringWithFormat:@"%@(%d)",[rs stringForColumn:@"name"],[prs intForColumnIndex:0]];
            }
            else
            {
                entity.name = [rs stringForColumn:@"name"];
            }
            
            entity.phone = [rs stringForColumn:@"phone"];
            
            [_recordData addObject:entity];
        }
    }
    
    [super reloadData];
}
@end
