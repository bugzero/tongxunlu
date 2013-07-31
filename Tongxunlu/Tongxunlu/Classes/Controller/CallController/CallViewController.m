//
//  CallViewController.m
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "CallViewController.h"
#import "TXLKeyBoard.h"
#import "CallRecord.h"

@interface CallViewController (){
    TXLKeyBoard*    _keyBoard;
    UIControl*      _maskView;
    UIControl*      _callView;
    CallRecord*     _callRecord;
}

-(void)loadKeyBoard;

-(void)loadCallRecord;

-(void)loadContent;
@end

@implementation CallViewController

-(id)initWithDefaultFrame:(CGRect)frame{
    self = [super initWithDefaultFrame:frame];
    
    if (self) {
        self.showNavigationBar = YES;
        self.callViewState = CallViewHide;
    }
    return self;
}

-(void)loadView{
    self.view = [[UIScrollView alloc]initWithFrame:self.defaultFrame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage themeImageNamed:@"bg_call.png"]];
    
//    [self showKeyBoard];
    [self performSelector:@selector(loadContent) withObject:nil afterDelay:0.2];
    
    [self setTitle:@"最近联系人"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark
#pragma -mark load content
-(void)loadContent{
    [self showKeyBoard];
    [self loadCallRecord];
}


-(void)loadCallRecord{
    _callRecord = [[CallRecord alloc]initWithFrame:CONTENT_VIEW_FRAME];
    
    [self.view addSubview:_callRecord];
}
#pragma -mark
#pragma -mark keyBoard method
-(void)loadKeyBoard{
    if (!_keyBoard) {
        _keyBoard = [[TXLKeyBoard alloc]initWithPosition:CGPointMake(0, self.view.height)];
    }
    
    if (_keyBoard.superview != self.view) {
        [self.view addSubview:_keyBoard];
    }
}

-(void)showKeyBoard{
    if (!_keyBoard) {
        [self loadKeyBoard];
    }
    
    if (!_maskView) {
        _maskView = [[UIControl alloc]initWithFrame:self.view.bounds];
        [_maskView addTarget:self action:@selector(willHide) forControlEvents:UIControlEventTouchUpInside];
    }
    EZNavigationController* navi = [EZinstance instanceWithKey:K_NAVIGATIONCTL];
    
    if (!_callView) {
        _callView = [[UIControl alloc]initWithFrame:CGRectMake(80, FULL_HEIGHT, 240, 49)];
        _callView.backgroundColor = [UIColor clearColor];
        [_callView addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* callbutton = [UIButton buttonWithTitle:nil image:[UIImage themeImageNamed:@"DialCallNormalBg"]  highlightedImage:[UIImage themeImageNamed:@"DialCallPressBg"] target:self action:@selector(sysCall)];
        callbutton.frame = CGRectMake(0, 0, 240, 49);
        [_callView addSubview:callbutton];
        
        [navi.view addSubview:_callView];
    }
    
    [UIView animateWithDuration:EZ_ANIMATION_DURATION animations:^{
        _keyBoard.bottom = self.view.height;
        
        UIScrollView* scollView = (UIScrollView*)self.view;
        
        scollView.contentOffset = CGPointMake(0,_navigationBar.height);
        
        _callView.bottom = FULL_HEIGHT;
        
    } completion:^(BOOL finished) {
        if (_maskView.superview != self.view) {
            [self.view addSubview:_maskView];
        }
        [self.view bringSubviewToFront:_keyBoard];
        
        self.callViewState = CallViewShow;
    }];
}

-(void)hideKeyBoard{
    if (!_keyBoard) {
        [self loadKeyBoard];
    }
    
    [UIView animateWithDuration:EZ_ANIMATION_DURATION animations:^{
        _keyBoard.top = self.view.height;
        
        UIScrollView* scollView = (UIScrollView*)self.view;
        
        scollView.contentOffset = CGPointMake(0,0);
        
        _callView.top = FULL_HEIGHT;
    } completion:^(BOOL finished) {
        [_maskView removeFromSuperview];
        self.callViewState = CallViewHide;
    }];
}

-(void)willHide{
    if ([self.delegate respondsToSelector:@selector(callViewControllerWillHideKeyBoard)]) {
        [self.delegate callViewControllerWillHideKeyBoard];
    }
    
    [self hideKeyBoard];
}

- (void)sysCall{
    if (isEmptyStr(_keyBoard.number)) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"号码为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    [EZinstance makeCall:_keyBoard.number];
}

@end
