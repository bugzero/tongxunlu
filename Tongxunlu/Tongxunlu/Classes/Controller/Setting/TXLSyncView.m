//
//  TXLSyncView.m
//  Tongxunlu
//
//  Created by 吴英杰 on 13-7-28.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "TXLSyncView.h"
#import "DictStoreSupport.h"


@implementation TXLSyncView

- (id)init{
    if (self) {
        _db = [EZinstance instanceWithKey:K_DBMANAGER];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"syncCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *title = nil;
    switch (indexPath.row) {
//        case 0:
//            title = @"备份个人通讯录";
//            break;
//        case 1:
//            title = @"恢复个人通讯录";
//            break;
        case 0:
            title = @"同步公司通讯录";
            break;
        case 1:
            title = @"同步共享通讯录";
            break;
            
        default:
            break;
    }
    CGRect tRect = CGRectMake(20,5, 320, 40);
    id lbl = [[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
    [lbl setText:title];
    [cell addSubview:lbl];
    return cell;
}



#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *userId = [DictStoreSupport readRtConfigWithKey:@"userId"];
    if (!userId) {
        userId = [NSNumber numberWithInt:0];
    }
    
    if (indexPath.row == 0) {
        syncCompData = YES;
        //请求部门数据
        [[EZRequest instance]postDataWithPath:@"/txlmain-manage/mobile/department/mobileSearch.txl" params:@{} success:^(NSDictionary *result) {
            NSArray  *departments = [result objectForKey:@"departs"];
            //默认先保存到字典文件，以后替换成sqlite
            if (departments && [departments count] > 0) {
                
                for (NSDictionary *dict in departments) {
                    int depId = [[dict objectForKey:@"depId"] intValue];
                    NSString *depName = [dict objectForKey:@"depName"];
                    int depParentId = [[dict objectForKey:@"depParentId"] intValue];
                    int compId = [[dict objectForKey:@"employeeNum"] intValue];
                    NSString  *sql = [NSString stringWithFormat:@"INSERT INTO `txl_department`(dep_id,dep_name,dep_parent_id,comp_id) VALUES(%d,'%@',%d,%d);",depId,depName,depParentId,compId];
                    [_db insertSql:sql];
                }
                [self showNotice:@"同步部门数据成功！"];
            }
        } failure:^(NSError *error) {
            [self showNotice:@"网络连接异常"];
            //        DBG(@"%@",error);
        }];
        
        NSString *compId = [TXLKeyChainHelper getUserNameWithService:USER_COMP_ID];
        if (isEmptyStr(compId)) {
            compId = @"";
        }
        [[EZRequest instance]postDataWithPath:@"/txlmain-manage/mobile/user/s/mobileSearch.txl" params:@{@"filter.name": @"",@"filter.depId":@"",@"filter.compId":compId} success:^(NSDictionary *result) {
//            [DictStoreSupport writeConfigWithKey:COMP_USER_CACHE_DATAS WithValue:[result objectForKey:@"users"]];
//            
//            [self showNotice:@"同步公司通讯录成功"];
//            
            
            NSArray  *users = [result objectForKey:@"users"];
            //默认先保存到字典文件，以后替换成sqlite
            if (users && [users count] > 0) {
                
                for (NSDictionary *dict in users) {
                    int userId = [[dict objectForKey:@"userId"] intValue];
                    int depId = [[dict objectForKey:@"depId"] intValue];
                    int compId = [[dict objectForKey:@"compId"] intValue];
                    NSString *name = [dict objectForKey:@"name"];
                    name = (name == nil?@"":name);
                    NSString *userPhone = [dict objectForKey:@"userPhone"];
                    userPhone = (userPhone == nil?@"":userPhone);
                    NSString *position = [dict objectForKey:@"position"];
                    position = (position == nil?@"":position);
                    NSString *compTel = [dict objectForKey:@"compTel"];
                    compTel = (compTel == nil?@"":compTel);
                    NSString *virtualTel = [dict objectForKey:@"virtualTel"];
                    virtualTel = (virtualTel == nil?@"":virtualTel);
                    NSString *homeTel = [dict objectForKey:@"homeTel"];
                    homeTel = (homeTel == nil?@"":homeTel);
                    NSString *email = [dict objectForKey:@"email"];
                    email = (email == nil?@"":email);
                    NSString *qq = [dict objectForKey:@"qq"];
                    qq = (qq == nil?@"":qq);
                    NSString *msn = [dict objectForKey:@"msn"];
                    msn = (msn == nil?@"":msn);
                    
                    NSString  *sql = [NSString stringWithFormat:@"INSERT INTO `txl_comp_user`(user_id,dep_id,comp_id,name,user_phone,position,comp_tel,virtual_tel,home_tel,email,qq,msn) VALUES(%d,%d,%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@')",userId,depId,compId,name,userPhone,position,compTel,virtualTel,homeTel,email,qq,msn];
                    [_db insertSql:sql];
                }
                [self showNotice:@"同步公司通讯录成功"];
            }
                 
            
            
        } failure:^(NSError *error) {
            [self showNotice:@"网络连接异常"];
            //        DBG(@"%@",error);
        }];
    }else if (indexPath.row == 1) {
        syncShareData = YES;
        NSString *compCode = [TXLKeyChainHelper getUserNameWithService:USER_COMP_CODE];
        if (isEmptyStr(compCode)){
            compCode = @"";
        }
        [[EZRequest instance]postDataWithPath:@"/txlshare-manage/mobile/shareBook/mobileSearch.txl" params:@{@"outUserId":userId,@"compCode":compCode,@"filter.sbName":@""} success:^(NSDictionary *result) {
            NSArray *_datas = [result objectForKey:@"shareBooks"];
            if (_datas && [_datas count] > 0) {
//                [DictStoreSupport writeConfigWithKey:SHARE_ALLIANCE_CACHE_DATAS WithValue:_datas];
                for (NSDictionary *dict in _datas) {
                    int sbId = [[dict objectForKey:@"sbId"] intValue];
                    NSString *sbName = [dict objectForKey:@"sbName"];
                    int userCount = [[dict objectForKey:@"userCount"] intValue];

                    NSString  *sql = [NSString stringWithFormat:@"INSERT INTO `txl_share_alliance`(sb_id,sb_name,user_count) VALUES(%d,'%@',%d);",sbId,sbName,userCount];
                    [_db insertSql:sql];

                }
                [self showNotice:@"同步共享通讯录" duration:2.0];
            }
        } failure:^(NSError *error) {
            [self showNotice:@"网络连接异常"];
            //        DBG(@"%@",error);
        }];
    }
}

@end
