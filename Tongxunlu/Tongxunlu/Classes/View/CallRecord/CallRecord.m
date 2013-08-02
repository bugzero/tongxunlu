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
#import "CallDetailCell.h"

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
        self.backgroundColor = RGB(238, 238, 238);
    }
    return self;
}

#pragma -mark 
#pragma -mark UITableViewDataSource & UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_recordData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString* identify = @"recordCellIdentify";
    
    AccountEntity* account = nil;
    if ([indexPath row] < [_recordData count]) {
        account = _recordData[[indexPath row]];
        if (![account isKindOfClass:[AccountEntity class]]) {
            account = nil;
        }
    }
    
    CallCell*    cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"recordCellIdentify%d",account.type]];
    
    if (!cell) {
        
        if (account.type == RECORD_DETAIL)
        {
            cell = [[CallDetailCell alloc]initWithReuseIdentifier:[NSString stringWithFormat:@"recordCellIdentify%d",account.type]];
        }
        else
        {
            cell = [[CallCell alloc]initWithReuseIdentifier:[NSString stringWithFormat:@"recordCellIdentify%d",account.type]];
            cell.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (cell && account) {
        [cell reloadDataWithEntity:account bEnd:(indexPath.row == _recordData.count-1)];
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
            [self showDetailWithData:account atIndex:indexPath];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (1 == buttonIndex && !isEmptyStr(_callNumber)) {
        [EZinstance makeCall:_callNumber];
    }
    _callNumber = @"";
}


-(void)delcell:(CallCell*)cell{
    if (!cell) {
        return;
    }
    NSIndexPath* path = [self indexPathForCell:cell];
    
    if (!path) {
        return;
    }
    
    // 数据库操作
    AccountEntity* account = nil;
    if ([path row] < [_recordData count]) {
        account = _recordData[[path row]];
        if (![account isKindOfClass:[AccountEntity class]]) {
            account = nil;
        }
    }
    
    DBManager* db = [EZinstance instanceWithKey:K_DBMANAGER];
    
    [db insertSql:[NSString stringWithFormat: @"delete from `callrecord` where phone='%@'",account.phone]];
    
    
    [_recordData removeObject:account];
    
    [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
}
//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    AccountEntity* account = nil;
//    if ([indexPath row] < [_recordData count]) {
//        account = _recordData[[indexPath row]];
//        if (![account isKindOfClass:[AccountEntity class]]) {
//            account = nil;
//        }
//    }
//    
//    return account.type == RECORD_COUNT;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_recordData removeObjectAtIndex:indexPath.row];
//        // Delete the row from the data source.
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        
//    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"删除记录";
//}

#pragma -mark
#pragma -mark delete

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

-(void)showDetailWithData:(AccountEntity*)data atIndex:(NSIndexPath*)indexPath{
    
    BOOL needClose = NO;
    
    if (!indexPath) {
        return;
    }
    
    if (indexPath.row+1 < _recordData.count) {
        AccountEntity* next = _recordData[indexPath.row+1];
        needClose = (RECORD_DETAIL == next.type);
    }
    
    // 关闭已经打开的
    NSMutableArray* delIndexs = [[NSMutableArray alloc]initWithCapacity:1];
    for (short index = _recordData.count-1 ; index >= 0; --index) {
        AccountEntity* acc = _recordData[index];
        if (acc.type == RECORD_DETAIL) {
            NSIndexPath* delPath = [NSIndexPath indexPathForRow:index inSection:indexPath.section];
            
            [delIndexs addObject:delPath];
            
            [_recordData removeObject:acc];
        }
    }
    
    if (delIndexs.count > 0 ) {
        [self deleteRowsAtIndexPaths:delIndexs withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    
    // 添加新的
    if (!needClose) {
        AccountEntity* account = [[AccountEntity alloc]init];
        account.phone = data.phone;
        account.type = RECORD_DETAIL;
        
        [_recordData insertObject:account atIndex:[_recordData indexOfObject:data]+1];
        
        NSIndexPath* path = [NSIndexPath indexPathForRow:[_recordData indexOfObject:data]+1 inSection:indexPath.section];
        [self insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}
@end
