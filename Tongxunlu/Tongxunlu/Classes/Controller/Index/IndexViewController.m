//
//  IndexViewController.m
//  Tongxunlu
//
//  Created by kongkong on 13-6-11.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "IndexViewController.h"
#import "EZNavigationController.h"
#import "SettingViewController.h"
#import "EZinstance.h"
#import "TXLSetting.h"
#import "ConnectViewController.h"
#import "DBManager.h"

@interface IndexViewController ()

@property(nonatomic,retain)EZTabbarController*  barController;
@property(nonatomic,retain)EZTabbarItem*        firstBarItem;
@property(nonatomic,retain)CallViewController*  callVC;
@property(nonatomic,assign)NSUInteger           preSelectTabIndex;
@property(nonatomic,retain)UIImageView*         _splashView;
@property(nonatomic,retain)UILabel*             statusLabel;

-(void)loadSplash;
-(void)enterHomePage;
-(void)loadSetting;
@end

@implementation IndexViewController

-(void)loadView{
    [super loadView];
    
    [self loadSplash];
}

//-(id)init{
//    
//    self = [super init];
//    
//    if (self) {
//        [self loadSetting];
//    }
//    return self;
//}

#pragma -mark
#pragma -mark splash 

-(void)loadSplash{
    if (!self._splashView) {
        self._splashView = [[UIImageView alloc]initWithFrame:FULL_VIEW_FRAME];
        if (IS_IPHONE5) {
            self._splashView.image = [UIImage imageNamed:@"Default-568h@2x"];
        }
        else{
            self._splashView.image = [UIImage imageNamed:@"Default"];
        }
        
        UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = self._splashView.center;
        [self._splashView addSubview:indicator];
        
        self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, FULL_WIDTH, 20)];
        self.statusLabel.font = FONT(15);
        self.statusLabel.backgroundColor = [UIColor clearColor];
        self.statusLabel.textColor = RGB(94, 94, 94);
        self.statusLabel.textAlignment = UITextAlignmentCenter;
        self.statusLabel.top = self._splashView.center.y+10;
        [self._splashView addSubview:self.statusLabel];
        
        [self.view addSubview:self._splashView];
        [indicator startAnimating];
    }
    [self loadSetting];
    [self loadDB];


}

-(void)loadDB{
    DBManager* db = [[DBManager alloc]init];
    
    [EZinstance setInstance:db key:K_DBMANAGER];
}

-(void)loadSetting{
    TXLSetting* setting = [[TXLSetting alloc]init];
    [EZinstance setInstance:setting key:K_SETTING];
    
    [setting loadSetting:^(NSString * status) {
        self.statusLabel.text = status;
    } complete:^{
        [self performSelector:@selector(enterHomePage) withObject:nil afterDelay:1];

    }];
}

-(void)enterHomePage{
    
    self.barController = [[EZTabbarController alloc]initWithDelegate:self];
//    [self.view addSubview:self.barController.view];
    self.preSelectTabIndex = -1;
    
    EZNavigationController* navigationBar = [[EZNavigationController alloc]initWithRootViewController:self.barController];
    
    /// 自动登陆
    User* user = [User instance];
    user.navigationCtl = navigationBar;
    
    [self.view addSubview:navigationBar.view];
    
    [EZinstance setInstance:navigationBar key:K_NAVIGATIONCTL];
}

#pragma -mark
#pragma -mark tabbar controller delegate
-(EZRootViewController *)viewControllerAtIndex:(NSUInteger)index{
    EZNavigationController* vcl = nil;
    
    switch (index) {
        case 0:{
            CallViewController* callVc = [[CallViewController alloc]initWithDefaultFrame:CGRectMake(0, 0, FULL_WIDTH, CONTENT_HEIGHT)];
            vcl = [[EZNavigationController alloc]initWithRootViewController:callVc];
            
//            [callVc showKeyBoard];
            self.callVC = callVc;
        }
            break;
        case 1:{
            ConnectViewController* connect = [[ConnectViewController alloc]initWithDefaultFrame:CGRectMake(0, 0, FULL_WIDTH, CONTENT_HEIGHT)];
            
            vcl = [[EZNavigationController alloc]initWithRootViewController:connect];
        }
            break;
        case 2:{
            EZRootViewController*   rootVc = [[EZRootViewController alloc]initWithDefaultFrame:CGRectMake(0, 0, FULL_WIDTH, CONTENT_HEIGHT)];
            
            rootVc.showNavigationBar = YES;
            [rootVc setTitle:@"免费信息"];
            
            vcl = [[EZNavigationController alloc]initWithRootViewController:rootVc];
        }
            break;
        case 3:{
            SettingViewController*   rootVc = [[SettingViewController alloc]initWithDefaultFrame:CGRectMake(0, 0, FULL_WIDTH, CONTENT_HEIGHT)];
            
            vcl = [[EZNavigationController alloc]initWithRootViewController:rootVc];
        }
            break;
        default:
            break;
    }
    return vcl;

}

-(NSUInteger)numberOfTabbarItems{
    return 4;
}

-(EZTabbarItem *)tabBarController:(EZTabbarController *)tabBarCtl itemAtIndex:(NSUInteger)index{
    EZTabbarItem* item = nil;
    
    switch (index) {
        case 0:{
            item = [[EZTabbarItem alloc]initWithTitle:@"展开"
                                                  icon:[UIImage themeImageNamed:@"TabKeyboardDialNormal.png"]
                                          selectedIcon:[UIImage themeImageNamed:@"TabKeyboardUpSelect.png"]];
            
            self.firstBarItem = item;
        }
            break;
        case 1:{
            item = [[EZTabbarItem alloc]initWithTitle:@"联系人"
                                                  icon:[UIImage themeImageNamed:@"TabContactNormal.png"]
                                          selectedIcon:[UIImage themeImageNamed:@"TabContactSelect.png"]];
        }
            break;
        case 2:{
            item = [[EZTabbarItem alloc]initWithTitle:@"信息"
                                                  icon:[UIImage themeImageNamed:@"TabMessageNormal.png"]
                                          selectedIcon:[UIImage themeImageNamed:@"TabMessageSelect.png"]];
        }
            break;
        case 3:{
            item = [[EZTabbarItem alloc]initWithTitle:@"设置"
                                                  icon:[UIImage themeImageNamed:@"TabContactNormal.png"]
                                          selectedIcon:[UIImage themeImageNamed:@"TabCenterSelect.png"]];
        }
            break;
        default:
            break;
    }
    
    return item;
}


-(void)tabbar:(EZTabbar *)tabbar didSelectedAtIndex:(NSUInteger)index tabbarItem:(EZTabbarItem *)item{
    if (index == 0) {
        
        if (self.preSelectTabIndex == index) {
            if (_callVC.callViewState == CallViewShow) {
                [item setTitle:@"展开"];
                [item setSelectedIcon:[UIImage themeImageNamed:@"TabKeyboardUpSelect.png"]];
                
                [self.callVC hideKeyBoard];
            }
            else{
                [item setTitle:@"收起"];
                [item setSelectedIcon:[UIImage themeImageNamed:@"TabKeyboardDownSelect.png"]];
                
                [self.callVC showKeyBoard];
            }
        }
    }
    else{
        [_firstBarItem setTitle:@"拨号"];

    }
    
    self.preSelectTabIndex = index;
}

-(BOOL)shouldLoadTabBarAtIndex:(NSUInteger)index{
    
    self.preSelectTabIndex = index;
    
    return YES;
}

#pragma -mark
#pragma -mark call view delegate
-(void)callViewControllerWillHideKeyBoard{
    if (self.preSelectTabIndex == 0) {
        [_firstBarItem setTitle:@"展开"];
        [_firstBarItem setSelectedIcon:[UIImage themeImageNamed:@"TabKeyboardUpSelect.png"]];
    }
}

@end
