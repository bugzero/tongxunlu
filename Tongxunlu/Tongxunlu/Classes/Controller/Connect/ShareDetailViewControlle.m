//
//  ShareSearchViewController.m
//  Tongxunlu
//
//  Created by 吴英杰 on 13-7-14.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "ShareDetailViewControlle.h"
#import "SearchCell.h"

@interface ShareDetailViewControlle ()
{
    NSMutableArray      *_datas;
}
@end

@implementation ShareDetailViewControlle

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
    
    [self setTitle:self.nameTitle];
//    _navigationBar.hidden = YES;
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.width, 44)];
    [self.view addSubview:_searchBar];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _searchBar.bottom, self.view.width, CONTENT_HEIGHT-_searchBar.height)];
    
    [self.view addSubview:_tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.searchBar.delegate = self;

    //先读缓存
    _datas = [DictStoreSupport readPoConfigWithKey:SHARE_DETAIL_CACHE_DATAS];
    if (!_datas) {
        _datas = [[NSMutableArray alloc]init];
    }
    
    [self searchBarSearchButtonClicked:self.searchBar];
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
    static NSString *CellIdentifier = @"SearchCell";
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[SearchCell alloc]init];
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
    if (isEmptyStr(keyword)) {
        keyword = @"";
    }
    NSNumber *userId = [DictStoreSupport readRtConfigWithKey:@"userId"];
    if (userId==0) {
        userId = [NSNumber numberWithInt:7];
    }
    NSString *compCode = [TXLKeyChainHelper getUserNameWithService:USER_COMP_CODE];
    if (!compCode) {
        compCode = @"ALIBABA";
    }
    //    if (![keyword isEqualToString:@""]) {
    [[EZRequest instance]postDataWithPath:@"/txlshare-manage/mobile/shareBookUser/mobileSearch.txl" params:@{@"outUserId":userId,@"compCode":compCode,@"filter.sbName":keyword,@"filter.sbId":[NSString stringWithFormat:@"%d",self.sbId]} success:^(NSDictionary *result) {
        _datas = [result objectForKey:@"shareBookUsers"];
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
