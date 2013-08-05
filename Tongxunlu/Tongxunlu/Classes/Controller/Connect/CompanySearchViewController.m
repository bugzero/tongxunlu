
//
//  CompanySearchViewController.m
//  Tongxunlu
//
//  Created by 吴英杰 on 13-7-11.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "CompanySearchViewController.h"
#import "SearchCell.h"
#import "CompanyDetailViewController.h"
#import "FPPopoverController.h"
#import "DeptChoiceViewController.h"
#import "DeptObject.h"
#import "DictStoreSupport.h"

#import "ListEntity.h"
#import "DepartsEntity.h"
#import "DBManager.h"


@interface CompanySearchViewController ()
{
    NSMutableArray      *_datas;
    NSMutableArray      *_deptDatas;
    DeptChoiceViewController *_deptViewCtl;
    FPPopoverController *_popover;
    NSString            *_deptId;
    NSArray             *_departs;
}
//@property (nonatomic, strong) FAFancyMenuView *menu;
@end

@implementation CompanySearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload
{
    _datas = nil;
    _deptDatas = nil;
    _deptViewCtl = nil;
    _popover = nil;
    _departs = nil;
    _deptId = nil;
}

- (void)deepArray:(NSArray*)topArray  noBingos:(NSMutableArray*)noBingos level:(int)level
{
    DeptObject *childDeptObj = nil;
    DeptObject *topObj = nil;
    for (int i = 0 ; i < [topArray count]; i++) {
        topObj = [topArray objectAtIndex:i];
        for (int j = 0 ; j < [noBingos count]; j++) {
            childDeptObj = [noBingos objectAtIndex:j];
            [childDeptObj setLevel:[NSString stringWithFormat:@"%d",level]];
            if (topObj.deptId == childDeptObj.depParentId) {
                if (topObj.depts == nil) {
                    topObj.depts = [[NSMutableArray alloc]init];
                }
                [topObj.depts addObject:childDeptObj];
//                [childDict setObject:@"1" forKey:@"level"];
                [noBingos removeObject:childDeptObj];
            }
        }
    }
}

- (void)buildDatas:(NSArray*)departs
{
    _deptDatas = [[NSMutableArray alloc]init];
    NSMutableArray  *noBingos = [[NSMutableArray alloc]init];
    DeptObject *deptObj = nil;
    for (NSMutableDictionary *dict in departs) {
        deptObj = [[DeptObject alloc]init];
        deptObj.deptId = [dict objectForKey:@"depId"];
        deptObj.name = [dict objectForKey:@"depName"];
        deptObj.depParentId = [dict objectForKey:@"depParentId"];
        if ([[dict objectForKey:@"depParentId"] intValue] ==0) {
            deptObj.level = 0;
            [_deptDatas addObject:deptObj];
        }else{
            [noBingos addObject:deptObj];
        }
    }
    
    [self deepArray:_deptDatas noBingos:noBingos level:1];
    
    for (int i = 0 ; i < [_deptDatas count]; i++) {
        DeptObject *topObj = [_deptDatas objectAtIndex:i];
        [self deepArray:topObj.depts noBingos:noBingos level:2];
    }

//    NSLog(@"%@",_deptDatas);
    
    
    NSDictionary *plistDict = [NSDictionary dictionaryWithObject:_deptDatas forKey:@"Objects" ];

    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"State.data"];
    
         // 序列化并保存到文件中
    [NSKeyedArchiver archiveRootObject:plistDict toFile:filePath];


}



- (void)viewWillAppear:(BOOL)animated
{
    
    if (syncCompData) {
        DBManager* db = [EZinstance instanceWithKey:K_DBMANAGER];
        
        FMResultSet* rs = [db excuteQuery:[NSString stringWithFormat:@"select * from `txl_department`"]];
        
        NSMutableArray *departs = [[NSMutableArray alloc]init];
        
        while ([rs next]) {
            NSMutableDictionary* entity = [[NSMutableDictionary alloc]init];
            [entity setObject:[rs stringForColumn:@"dep_name"] forKey:@"name"];
            [entity setObject:[rs stringForColumn:@"dep_id"] forKey:@"depId"];
            [entity setObject:[rs stringForColumn:@"dep_parent_id"] forKey:@"depParentId"];
            [entity setObject:[rs stringForColumn:@"comp_id"] forKey:@"compId"];
            [departs addObject:entity];
        }
        
        [self buildDatas:departs];
    }else{
        //请求部门数据
        if (_departs==nil) {
            [[EZRequest instance]postDataWithPath:@"/txlmain-manage/mobile/department/mobileSearch.txl" params:@{} success:^(NSDictionary *result) {
                
                _departs = [result objectForKey:@"departs"];
                [self buildDatas:_departs];
                
            } failure:^(NSError *error) {
                [self showNotice:@"网络连接异常"];
            }];
        }

    }
    
    _datas = [[NSMutableArray alloc]init];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollsToTop = YES;
    
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"输入员工姓名";
    
    _deptId = @"";
    
    _deptViewCtl = [[DeptChoiceViewController alloc] initWithNibName:@"DeptChoiceViewController" bundle:nil];
    _deptViewCtl.delegate = self;
    
    _popover = [[FPPopoverController alloc] initWithViewController:_deptViewCtl];
    
    _datas = [[NSMutableArray alloc]init];

    [self.tableView reloadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showAnimation:(id)sender {
    //popover.arrowDirection = FPPopoverArrowDirectionAny;
    _popover.tint = FPPopoverDefaultTint;
    
    _popover.contentSize = CGSizeMake(300, 400);
    
    _popover.arrowDirection = FPPopoverArrowDirectionAny;
    
    //sender is the UIButton view
    [_popover presentPopoverFromView:sender];

    
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


- (void)closePopView
{
    _deptId = [[NSUserDefaults standardUserDefaults]objectForKey:@"searchDeptId"];
    [_popover dismissPopoverAnimated:YES];
    [self searchBarSearchButtonClicked:_searchBar];
}

- (IBAction)searchAction:(id)sender {
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    SearchCell *cell = (SearchCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return 55;
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
//    NSArray *images = @[[UIImage imageNamed:@"sms"],[UIImage imageNamed:@"phone"]];
    FAFancyMenuView *menu = [[FAFancyMenuView alloc] init];
    menu.delegate = self;
    menu.buttonImages = @[[UIImage imageNamed:@"sms"],[UIImage imageNamed:@"phone"]];
    menu.mobilePhone = cell.userPhoneLabel.text;
    UIView  *menuView = [[UIView alloc]initWithFrame:CGRectMake(100, 0, 220, 54)];
    [menuView addSubview:menu];
    [cell.contentView addSubview:menuView];
    return cell;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    NSString *keyword = [searchBar text];
    
    if (keyword==nil) {
        keyword = @"";
    }
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    keyword = [keyword stringByTrimmingCharactersInSet:whitespace];
    
    if (syncCompData) {//查数据库
        
        DBManager* db = [EZinstance instanceWithKey:K_DBMANAGER];
        
        FMResultSet* rs = [db excuteQuery:[NSString stringWithFormat:@"select * from `txl_comp_user` WHERE name != '(null)' and name like '%%%@%%' ",keyword]];
        
        _datas = [[NSMutableArray alloc]init];
        
        while ([rs next]) {
//            NSLog(@"%@",[rs stringForColumn:@"name"]);
            NSMutableDictionary* entity = [[NSMutableDictionary alloc]init];
            [entity setObject:[rs stringForColumn:@"comp_id"] forKey:@"compId"];
            [entity setObject:[rs stringForColumn:@"comp_tel"] forKey:@"compTel"];
            [entity setObject:[rs stringForColumn:@"dep_id"] forKey:@"depId"];
            [entity setObject:[rs stringForColumn:@"name"] forKey:@"name"];
            [entity setObject:[rs stringForColumn:@"email"] forKey:@"email"];
            [entity setObject:[rs stringForColumn:@"home_tel"] forKey:@"homeTel"];
            [entity setObject:[rs stringForColumn:@"msn"] forKey:@"msn"];
            [entity setObject:[rs stringForColumn:@"position"] forKey:@"position"];
            [entity setObject:[rs stringForColumn:@"qq"] forKey:@"qq"];
            [entity setObject:[rs stringForColumn:@"user_id"] forKey:@"userId"];
            [entity setObject:[rs stringForColumn:@"user_phone"] forKey:@"userPhone"];
            [entity setObject:[rs stringForColumn:@"virtual_tel"] forKey:@"virtualTel"];
            
            [_datas addObject:entity];
        }
        
        [self.tableView reloadData];
        
    }else{
        NSString *compId = [TXLKeyChainHelper getUserNameWithService:USER_COMP_ID];
        [[EZRequest instance]postDataWithPath:@"/txlmain-manage/mobile/user/s/mobileSearch.txl" params:@{@"filter.name": keyword,@"filter.depId":_deptId,@"filter.compId":compId} success:^(NSDictionary *result) {
            _datas = [result objectForKey:@"users"];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [self showNotice:@"网络连接异常"];
            //        DBG(@"%@",error);
        }];
    }
    [searchBar resignFirstResponder];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    CompanyDetailViewController *detailVc = [[CompanyDetailViewController alloc] initWithNibName:@"CompanyDetailViewController" bundle:nil];
    [detailVc setShowDatas:[_datas objectAtIndex:indexPath.row]];
    EZNavigationController* navi = [EZinstance instanceWithKey:K_NAVIGATIONCTL];
    if (navi) {
        [navi pushViewController:detailVc];
    }
}

@end
