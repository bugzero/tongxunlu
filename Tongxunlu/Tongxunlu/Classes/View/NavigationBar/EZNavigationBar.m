//
//  EZNavigationBar.m
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "EZNavigationBar.h"
#import <QuartzCore/QuartzCore.h>



@implementation EZNavigationBar

@synthesize title = _title;
@synthesize titleView = _titleView;
@synthesize leftBarButton = _leftBarButton;
@synthesize rightBarButton = _rightBarButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = NO;
        self.layer.contents = (id)[UIImage themeImageNamed:@"NavBar.png"].CGImage;
        [self addShadow];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    if (nil == _titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake((self.width - 200)/2, 0, 200, self.height)];
    }else {
        [_titleView removeAllSubviews];
    }
    _titleView.frame = CGRectMake((self.width - 200)/2, 0, 200, self.height);
    _titleView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, _titleView.height - 10)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = _title;
    titleLabel.tag = TAG_TITLELB;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumFontSize = 14;
    titleLabel.shadowColor = RGBA(180, 0, 39,0.55f);
    titleLabel.shadowOffset = CGSizeMake(-1, 0);
    [_titleView addSubview:titleLabel];
    
    [_titleView removeFromSuperview];
    [self addSubview:_titleView];
}

- (void)setTitleColor:(UIColor*)color
{
    UILabel *titleLabel = (UILabel*)[_titleView viewWithTag:TAG_TITLELB];
    titleLabel.textColor = color;
}

- (void)setTitleView:(UIView *)titleView
{
    [_titleView removeFromSuperview];
    _titleView = nil;
    if (titleView) {
        _titleView = titleView;
        _titleView.center = self.center;
        [self addSubview:_titleView];
    }
}

- (void)setLeftBarButton:(UIView *)leftBarButton
{
    [_leftBarButton removeFromSuperview];
    _leftBarButton = nil;
    if (leftBarButton) {
        _leftBarButton = leftBarButton;
        _leftBarButton.center = CGPointMake(_leftBarButton.width/2+5, self.height/2);
        
        [self addSubview:_leftBarButton];
    }
}

- (void)setRightBarButton:(UIView *)rightBarButton
{
    [_rightBarButton removeFromSuperview];
    _rightBarButton = nil;
    if (rightBarButton) {
        _rightBarButton = rightBarButton;
        _rightBarButton.center = CGPointMake(self.width - (_rightBarButton.width/2)-5, self.height/2);
        [self addSubview:_rightBarButton];
        [self bringSubviewToFront:_rightBarButton];
    }
}

- (void)addShadow
{
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.7;
    self.layer.shadowRadius = 3;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

- (void)removeShadow
{
    self.layer.shadowColor = nil;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0;
}

@end
