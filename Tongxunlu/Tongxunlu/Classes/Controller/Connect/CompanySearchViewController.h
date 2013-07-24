//
//  CompanySearchViewController.h
//  Tongxunlu
//
//  Created by 吴英杰 on 13-7-11.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "EZRootViewController.h"
#import "DeptChoiceViewController.h"
#import "FAFancyMenuView.h"
#import <MessageUI/MFMessageComposeViewController.h>

@interface CompanySearchViewController : EZRootViewController<FAFancyMenuViewDelegate,CloseDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate>

@property(strong, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)showAnimation:(id)sender;

- (IBAction)searchAction:(id)sender;
@end
