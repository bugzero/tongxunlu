//
//  EZRootViewController.m
//  Tongxunlu
//
//  Created by kongkong on 13-6-11.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "EZRootViewController.h"
#import "EZNavigationController.h"

@interface EZRootViewController ()
-(void)addNavigationBar;
@end

@implementation EZRootViewController

-(id)init{
    self = [super init];
    if (self) {
        _showNavigationBar = NO;
    }
    return self;
}

-(id)initWithDefaultFrame:(CGRect)frame{
    self = [self init];
    
    if (self) {
        self.defaultFrame = frame;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!CGRectIsEmpty(self.defaultFrame)) {
        self.view.frame = self.defaultFrame;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addNavigationBar];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark
#pragma -mark navigation bar
-(void)addNavigationBar{
    if (!_navigationBar) {
        _navigationBar = [[EZNavigationBar alloc]initWithFrame:CGRectMake(0, 0, FULL_WIDTH, NAVBAR_HEIGHT)];
    }
    
    if (!_showNavigationBar) return;
    
    if (_navigationBar.superview != self.view) {
        [self.view addSubview:_navigationBar];
    }
}

-(void)setTitle:(NSString*)title{
    [self addNavigationBar];
    
    [_navigationBar setTitle:title];
}

-(void)setTitleView:(UIView*)titleView{
    [self addNavigationBar];
    
    [_navigationBar setTitleView:titleView];
}

-(void)setLeftbarItem:(UIView*)leftBarItem{
    [self addNavigationBar];
    
    [_navigationBar setLeftBarButton:leftBarItem];
}

-(void)setRightbarItem:(UIView*)rightBarItem{
    [self addNavigationBar];

    [_navigationBar setRightBarButton:rightBarItem];
}

- (void)back {
    [self.ezNavigationController popViewControllerWithAnimation:_animationType];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation  == UIInterfaceOrientationPortrait);
}
@end
