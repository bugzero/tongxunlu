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
    return 53;
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
    FAFancyMenuView *menu = [[FAFancyMenuView alloc] init];
    menu.delegate = self;
    menu.buttonImages = @[[UIImage imageNamed:@"sms"],[UIImage imageNamed:@"phone"]];
    menu.mobilePhone = cell.userPhoneLabel.text;
    UIView  *menuView = [[UIView alloc]initWithFrame:CGRectMake(100, 0, 220, 54)];
    [menuView addSubview:menu];
    [cell.contentView addSubview:menuView];
    return cell;
}

- (void)fancyMenu:(FAFancyMenuView *)menu didSelectedButtonAtIndex:(NSUInteger)index{
    if (index==0) {
        Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
        if (messageClass != nil) {
            // Check whether the current device is configured for sending SMS messages
            if ([messageClass canSendText]) {
                [self displaySMSComposerSheet:menu.mobilePhone];
            }
            else {
                [self showNotice:@"设备没有短信功能" duration:2.0];
                
            }
        }
        else {
            [self showNotice:@"iOS版本过低,iOS4.0以上才支持程序内发送短信" duration:2.0];
        }
    }else if(index==1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",menu.mobilePhone]]];
    }
}

-(void)displaySMSComposerSheet:(NSString*)mobilePhone
{
    
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    
    picker.recipients = [NSArray arrayWithObjects:mobilePhone, nil];
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
    //    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    //    picker.messageComposeDelegate = self;
    //
    //    [self presentModalViewController:picker animated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            // LOG_EXPR(@"Result: SMS sending canceled");
            [self showNotice:@"短信发送取消" duration:2.0];
            break;
        case MessageComposeResultSent:
            // LOG_EXPR(@"Result: SMS sent");
            [self showNotice:@"短信已发送成功" duration:2.0];
            break;
        case MessageComposeResultFailed:
            //[UIAlertView quickAlertWithTitle:@"短信发送失败" messageTitle:nil dismissTitle:@"关闭"];
            [self showNotice:@"短信发送失败" duration:2.0];
            break;
        default:
            // LOG_EXPR(@"Result: SMS not sent");
            [self showNotice:@"SMS not sent" duration:2.0];
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
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
