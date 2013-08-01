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
#import "CallCell.h"

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
    
    CallCell*    cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    AccountEntity* account = nil;
    if ([indexPath row] < [_recordData count]) {
        account = _recordData[[indexPath row]];
        if (![account isKindOfClass:[AccountEntity class]]) {
            account = nil;
        }
    }
    
    if (!cell) {
        cell = [[CallCell alloc]initWithStyle:account.type
                                     reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (cell && account) {
        [cell reloadDataWithEntity:account];
//        cell.textLabel.text = account.name;
//        cell.detailTextLabel.text = account.phone;
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
        
        if (account.type == RECORD_COUNT) {
            [self showDetailWithData:account];
        }
        else{
            _callNumber = [[NSString alloc]initWithString:account.phone];
            
            NSString* message = [NSString stringWithFormat:@"是否拨打 号码:%@",account.phone];
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"拨号" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
            [alert show];
        }
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
    
    [_recordData removeAllObjects];
    
    DBManager* db = [EZinstance instanceWithKey:K_DBMANAGER];
    
    if (db) {
        FMResultSet* rs =[db excuteQuery:@"select count(*),phone,name,time from `callrecord` group by phone"];
        while ([rs next]) {
            AccountEntity* entity = [[AccountEntity alloc]init];
            
            entity.count = [[rs stringForColumnIndex:0]intValue];
            entity.name = [rs stringForColumn:@"name"];
            entity.time = [rs doubleForColumn:@"time"];
            entity.type = RECORD_COUNT;
            
            entity.phone = [rs stringForColumn:@"phone"];
            
            [_recordData addObject:entity];
        }
    }
    
    [super reloadData];
}

-(void)showDetailWithData:(AccountEntity*)data{
    
    short index = [_recordData indexOfObject:data];
    
    BOOL onlyRemove = NO;
    
    if (index+1 < _recordData.count) {
        AccountEntity* next = _recordData[index+1];
        if ([data.phone isEqualToString:next.phone]) {
            onlyRemove = YES;
        }
    }
    
    for (index = _recordData.count -1; index>=0; --index) {
        AccountEntity* account = _recordData[index];
        if (account.type == RECORD_DETAIL) {
            [_recordData removeObjectAtIndex:index];
        }
    }
    
    if (!onlyRemove) {
    
        DBManager* db = [EZinstance instanceWithKey:K_DBMANAGER];
        
        if (db && !isEmptyStr(data.phone)) {
            FMResultSet* rs = [db excuteQuery:[NSString stringWithFormat:@"select * from `callrecord` where phone='%@'",data.phone]];
            
            index = [_recordData indexOfObject:data];
            
            while ([rs next]) {
                AccountEntity* entity = [[AccountEntity alloc]init];
                
                entity.count = [[rs stringForColumnIndex:0]intValue];
                entity.name = [rs stringForColumn:@"name"];
                entity.time = [rs doubleForColumn:@"time"];
                entity.type = RECORD_DETAIL;
                
                entity.phone = [rs stringForColumn:@"phone"];

                
                [_recordData insertObject:entity atIndex:index+1];
    //            [_recordData addObject:entity];
            }
        }
    }
    
    [super reloadData];
}
@end
