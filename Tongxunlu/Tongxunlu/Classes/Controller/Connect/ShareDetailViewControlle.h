//
//  ShareSearchViewController.h
//  Tongxunlu
//
//  Created by 吴英杰 on 13-7-14.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "EZRootViewController.h"
#import "FAFancyMenuView.h"
#import <MessageUI/MFMessageComposeViewController.h>

@interface ShareDetailViewControlle : EZRootViewController<FAFancyMenuViewDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) UITableView *tableView;

@property (assign, nonatomic) int   sbId;

@property (strong, nonatomic) NSString  *nameTitle;
@end
