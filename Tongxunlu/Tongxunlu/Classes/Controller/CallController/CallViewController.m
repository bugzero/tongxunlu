//
//  CallViewController.m
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "CallViewController.h"
#import "TXLKeyBoard.h"

@interface CallViewController (){
    TXLKeyBoard*     _keyBoard;
    UIControl*       _maskView;
    UIControl*       _callView;
}

-(void)loadKeyBoard;
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
    
    [self setTitle:@"最近联系人"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        _callView = [[UIControl alloc]initWithFrame:CGRectMake(80, 100, 240, 49)];
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
    [self makeCall:_keyBoard.number];
}

- (void)makeCall:(NSString *)number
{
//    NSString *txt = number;
    NSURL* telUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",number]];
    [[UIApplication sharedApplication] openURL:telUrl];
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]{4}[-]{0,1}[0-9]{4}?" options:NSRegularExpressionCaseInsensitive error:nil];
//    NSTextCheckingResult *result = [regex firstMatchInString:txt options:0 range:NSMakeRange(0, [txt length])];
//    NSString *cleanedString = [[[txt substringWithRange:[result range]] componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
//    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", escapedPhoneNumber]];
//    [[UIApplication sharedApplication] openURL:telURL];
}

@end
