//
//  TXLSyncView.m
//  Tongxunlu
//
//  Created by 吴英杰 on 13-7-28.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "TXLSyncView.h"

@implementation TXLSyncView


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"syncCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    NSString *title = nil;
    switch (indexPath.row) {
        case 0:
            title = @"备份个人通讯录";
            break;
        case 1:
            title = @"恢复个人通讯录";
            break;
        case 2:
            title = @"同步公司通讯录";
            break;
        case 3:
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

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
