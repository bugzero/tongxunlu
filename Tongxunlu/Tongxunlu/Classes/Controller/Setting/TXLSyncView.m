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
            NSArray  *department = [result objectForKey:@"departs"];
            //默认先保存到字典文件，以后替换成sqlite
            if (department && [department count] > 0) {
                [DictStoreSupport writeConfigWithKey:COMP_DEPT_CACHE_DATAS WithValue:department];
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
            //_datas = [result objectForKey:@"users"];
            [DictStoreSupport writeConfigWithKey:COMP_USER_CACHE_DATAS WithValue:[result objectForKey:@"users"]];
            [self showNotice:@"同步公司通讯录成功"];
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
                [DictStoreSupport writeConfigWithKey:SHARE_ALLIANCE_CACHE_DATAS WithValue:_datas];
            }
            [self showNotice:@"同步共享通讯录" duration:2.0];
        } failure:^(NSError *error) {
            [self showNotice:@"网络连接异常"];
            //        DBG(@"%@",error);
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
