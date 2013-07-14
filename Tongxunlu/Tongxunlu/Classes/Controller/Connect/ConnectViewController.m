//
//  ConnectViewController.m
//  Tongxunlu
//
//  Created by kongkong on 13-6-13.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "ConnectViewController.h"
#import "EZNavigationController.h"
#import "EZActionSheet.h"
#import "DropDownTitleView.h"
#import "CompanySearchViewController.h"
#import "ShareSearchViewController.h"  

static NSArray* dropList = nil;///@{@"个人通讯录",@"公司讯录",@"共享通讯录"};

@interface ConnectViewController (){
    ContractViewController* _contractVC;
    CompanySearchViewController *_companyVC;
    ShareSearchViewController   *_shareVC;
    UIView*                 _contentView;
    NSInteger               _currentSelected;
    
    DropDownTitleView*      _dropDownTitleView;
}

-(void)loadContent;
@end

@implementation ConnectViewController

-(id)initWithDefaultFrame:(CGRect)frame{
    self = [super initWithDefaultFrame:frame];
    
    if (self) {
        self.showNavigationBar = YES;
        
        _currentSelected = 0;
        
        dropList = [NSArray arrayWithObjects:@"个人通讯录",@"公司通讯录",@"共享通讯录", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage themeImageNamed:@"bg_call.png"]];
    
    /// add title View
    [self addTitleView];
    
    _contentView = [[UIView alloc]initWithFrame:CONTENT_VIEW_FRAME];
    [self.view addSubview:_contentView];
    
    [self reloadView];
    
    [self loadDropDownList];
    
    UIButton* leftBtn = [UIButton barButtonWithTitle:@"注销" target:self action:@selector(actionSheet)];
    
    [self setLeftbarItem:leftBtn];
}

-(void)actionSheet{
//    EZNavigationController* navi = [EZinstance instanceWithKey:K_NAVIGATIONCTL];
//    
//    if (navi) {
//        EZActionSheet* action = [[EZActionSheet alloc]initWithFrame:CGRectMake(0, 0, FULL_WIDTH, 300) delegate:nil cancelButtonTitle:@"取消" confirmButtonTitle:nil];
//        
//        [action showActionSheetFromView:navi.view];
//    }
    [User logout];
    
}



-(void)loadDropDownList{
    self.dropDownList =  [[MXDropDownList alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height) listData:dropList];
    
    self.dropDownList.listType = ForChallenge;
    
    self.dropDownList.delegate = self;
    self.dropDownList.hidden = YES;
    
    [self.view addSubview:self.dropDownList];
    
    [self addTitleView];
}

-(void)addTitleView{
    
    if (_dropDownTitleView) {
        return;
    }
    
    _dropDownTitleView = [[DropDownTitleView alloc]initWithFrame:CGRectMake(0, 0, 120,35)
                                                           title:dropList[0]
                                                          action:self
                                                        selector:@selector(dropDownSwitch)];
    
    [self setTitleView:_dropDownTitleView];
}

-(BOOL)dropDownListValueWillChanged:(NSString *)selectedValue index:(int)index{
    switch (index) {
        case 1:{
            if (![[User instance]isLogin]) {
                [User loginWithBlock:^{
                    _currentSelected = 1;
                    [self closeDropDownList];
                    [self loadComp];
                    [_dropDownTitleView setLabel:dropList[_currentSelected]];
                }];
                return NO;
            }
        }
        case 2:{
            if (![[User instance]isLogin]) {
                [User loginWithBlock:^{
                    _currentSelected = 2;
                    [self closeDropDownList];
                    [self loadShare];
                    [_dropDownTitleView setLabel:dropList[_currentSelected]];
                }];
                return NO;
            }
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}

- (void)dropDownListValueChanged:(NSString *)selectedValue index:(int) index
{
    if (index < [dropList count]) {
        [_dropDownTitleView setLabel:dropList[index]];
        [self closeDropDownList];
        
        switch (index) {
            case 0:
                [self loadContract];
                break;
            case 1:
                [self loadComp];
                break;
            case 2:
                [self loadShare];
                break;
            default:
                break;
        }
    }
}

-(void)dropDownSwitch{
    if (_dropDownTitleView.drapFlag){
        [self closeDropDownList];
    }
    else{
        [self openDropDownList];
    }
}
#pragma mark - Local  Methods
- (void)closeDropDownList
{
    [self.dropDownList hideDropDownList];

    _dropDownTitleView.drapFlag = !_dropDownTitleView.drapFlag;
}

- (void)openDropDownList
{
    [self.dropDownList showDropDownList];

    _dropDownTitleView.drapFlag = !_dropDownTitleView.drapFlag;
}

#pragma -mark
#pragma -mark reload view for navigation bar selection
-(void)reloadView{
    switch (_currentSelected) {
        case 0:
            [self loadContract];
            break;
        case 1:
            [self loadComp];
            break;
        default:
            break;
    }
    [_dropDownTitleView setLabel:dropList[_currentSelected]];
}

-(void)loadContract{
    
    if (!_contractVC) {
        _contractVC = [[ContractViewController alloc]init];
    }
    _contractVC.delegate = self;
    [_contentView removeAllSubviews];
    [_contentView addSubview:_contractVC.view];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    [btn addTarget:self action:@selector(insertNewObject:) forControlEvents:UIControlEventTouchUpInside];
    [self setRightbarItem:btn];
    
}
- (void)clickABPerson:(ABNewPersonViewController*)person
{
    if (person) {
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:person];

        [self presentModalViewController:navigation animated:YES];
    }
}
//新建联系人
- (void)insertNewObject:(id)sender
{
    ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
	picker.newPersonViewDelegate = self;
	
	UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:picker];
	[self presentModalViewController:navigation animated:YES];
}

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
	[self dismissModalViewControllerAnimated:YES];
}

-(void)loadComp{
    if (!_companyVC) {
        _companyVC = [[CompanySearchViewController alloc]init];
        _companyVC.ezNavigationController = self.ezNavigationController;
    }
    if (_companyVC.view.superview != _contentView) {
        
        [_contentView removeAllSubviews];
        [_contentView addSubview:_companyVC.view];
    }
}

-(void)loadShare{
    if (!_shareVC) {
        _shareVC = [[ShareSearchViewController alloc] initWithNibName:@"ShareSearchViewController" bundle:nil];
    }
    
    if (_shareVC.view.superview != _contentView) {
        
        [_contentView removeAllSubviews];
        [_contentView addSubview:_shareVC.view];
    }
}

-(void)loadContent{
//    ContractView *contract = [[ContractView alloc]initWithFrame:CONTENT_VIEW_FRAME];
//    
//    [self.view addSubview:contract];
//
    
    if (_contractVC) {
        return;
    }
    
    _contractVC = [[ContractViewController alloc]init];
    
    //[self.view addSubview:_contractVC.view];
    
    if (_contractVC.view.superview != _contentView) {
        
        [_contentView removeAllSubviews];
        [_contentView addSubview:_contractVC.view];
    }
}

@end
