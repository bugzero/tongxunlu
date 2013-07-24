//
//  ShareSearchViewController.m
//  Tongxunlu
//
//  Created by 吴英杰 on 13-7-14.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "ShareSearchViewController.h"
#import "ShareCell.h"
#import "ShareDetailViewControlle.h"
#import "EZNavigationController.h"


@interface ShareSearchViewController ()
{
    NSMutableArray      *_datas;
}
@end

@implementation ShareSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.searchBar.delegate = self;

    
    //先读缓存
    _datas = [DictStoreSupport readPoConfigWithKey:SHARE_ALLIANCE_CACHE_DATAS];
    if (!_datas) {
        _datas = [[NSMutableArray alloc]init];
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    SearchCell *cell = (SearchCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShareCell";
    ShareCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ShareCell alloc]init];
    }
    [cell setData:[_datas objectAtIndex:indexPath.row]];
    return cell;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *keyword = searchBar.text;
    NSNumber *userId = [DictStoreSupport readRtConfigWithKey:@"userId"];
//    if (userId==0) {
//        userId = [NSNumber numberWithInt:7];
//    }
    NSString *compCode = [TXLKeyChainHelper getUserNameWithService:USER_COMP_CODE];
    if (!compCode) {
        compCode = @"ALIBABA";
    }
    //    if (![keyword isEqualToString:@""]) {
    [[EZRequest instance]postDataWithPath:@"/txlshare-manage/mobile/shareBook/mobileSearch.txl" params:@{@"outUserId":userId,@"compCode":compCode,@"filter.sbName":keyword} success:^(NSDictionary *result) {
        _datas = [result objectForKey:@"shareBooks"];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self showNotice:@"网络连接异常"];
        //        DBG(@"%@",error);
    }];
    //    }
    [searchBar resignFirstResponder];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    ShareDetailViewControlle *detailVc = [[ShareDetailViewControlle alloc] init];///WithNibName:@"ShareDetailViewControlle" bundle:nil];
    NSDictionary   *dict = [_datas objectAtIndex:indexPath.row];
    detailVc.sbId = [[dict objectForKey:@"sbId"] intValue];
    detailVc.nameTitle = [NSString stringWithFormat:@"%@(%d)",[dict objectForKey:@"sbName"],[[dict objectForKey:@"userCount"] intValue]];
    EZNavigationController* navi = [EZinstance instanceWithKey:K_NAVIGATIONCTL];
    if (navi) {
        [navi pushViewController:detailVc];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSearchBar:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
