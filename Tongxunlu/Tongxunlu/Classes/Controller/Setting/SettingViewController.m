//
//  SettingViewController.m
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "SettingViewController.h"
#import "EZNavigationController.h"

@interface SettingViewController ()
{
    SiteViewCtl     *_viewCtl;
}
@end

@implementation SettingViewController


-(id)initWithDefaultFrame:(CGRect)frame{
    self = [super initWithDefaultFrame:frame];
    
    if (self) {
        self.showNavigationBar = YES;
        _viewCtl = [[SiteViewCtl alloc] initWithNibName:@"SiteViewCtl" bundle:nil];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage themeImageNamed:@"bg_call.png"]];
    
    [self setTitle:@"个人中心"];
    
    UIButton* rightBtn = [UIButton barButtonWithTitle:@"设置" target:self action:@selector(setting)];
    
    [self.view addSubview:_viewCtl.view];
    
    [self setRightbarItem:rightBtn];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setting{
    EZRootViewController* view = [[EZRootViewController alloc]init];
    
    [self.ezNavigationController pushViewController:view];
}

@end
