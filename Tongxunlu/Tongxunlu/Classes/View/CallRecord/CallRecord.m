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

@interface CallRecord(){
    NSMutableArray*     _recordData;
}

@end

@implementation CallRecord

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
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
        if (account) {
            cell.textLabel.text = account.name;
        }
        
    }
    
    if (cell && account) {
    }
    
    return cell;
}
@end
