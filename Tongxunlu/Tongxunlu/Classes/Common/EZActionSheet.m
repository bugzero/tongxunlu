//
//  EZActionSheet.m
//  Tongxunlu
//
//  Created by kongkong on 13-6-13.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "EZActionSheet.h"
#import <QuartzCore/QuartzCore.h>

@interface EZActionSheet()
- (void)initContent;
@end

@implementation EZActionSheet
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame delegate:nil cancelButtonTitle:@"取消" confirmButtonTitle:nil];
}


- (id)initWithFrame:(CGRect)frame delegate:(id<EZActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        //add topbar
        UIImageView *topBarBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_acionsheet_bar.png"]];
        topBarBG.frame = CGRectMake(0.0f, 0.0f, 320.0f, 50.0f);
        [self addSubview:topBarBG];
        
        if (nil != cancelButtonTitle) {
            
            _cancelBtn = [UIButton blackButtonWithTitle:cancelButtonTitle image:[UIImage imageNamed:@"btn_cancel.png"] highlightedImage:[UIImage imageNamed:@"btn_cancel_selected.png"] target:self action:@selector(cancel:)];
            _cancelBtn.frame = CGRectMake(12, 3, 72, 44);
            _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
            
            
            [self addSubview:_cancelBtn];
        }
        
        if (nil != confirmButtonTitle) {
            //add go button:
            _goBtn = [UIButton redButtonWithTitle:confirmButtonTitle image:[UIImage imageNamed:@"btn_confirm.png"] highlightedImage:[UIImage imageNamed:@"btn_confirm_selected.png"] target:self action:@selector(go:)];
            _goBtn.frame = CGRectMake(6.0f, 3, 72, 44);
            _goBtn.frame = CGRectMake(self.width - _goBtn.width- 6.0f, 3.0f, 72, 44);
            _goBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
            
            [self addSubview:_goBtn];
        }
        
        [self initContent];
    }
    return self;
}

- (void)initContent
{
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 50.0f, 320.0f, self.height-50.0f)];
    //    _contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_main_bg.png"]];
    _contentView.backgroundColor = RGB(238,238,238);
    [self addSubview:_contentView];
}

- (void)setContent:(UIView *)content
{
    content.frame = CGRectMake(0.0f, 30.0f, 320.0f, self.height-30.0f);
    [_contentView addSubview:content];
}

- (void)showActionSheetFromView:(UIView *)view
{
    _parentView = view;
    //添加mask:
    if (nil == _maskView) {
        _maskView = [[UIControl alloc] initWithFrame:_parentView.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.0f;
    }
    
    CGRect actionsheetF = self.frame;
    CGRect selfF = _parentView.frame;
    CGRect changeF  = CGRectMake(0, selfF.size.height-actionsheetF.size.height, selfF.size.width, actionsheetF.size.height);
    self.top = _parentView.height;
    
    
    //view截图:
    if (nil == _overlay) {
        _overlay = [[UIView alloc] initWithFrame:_parentView.bounds];
        _overlay.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_actionsheet"]];
    }
    UIGraphicsBeginImageContextWithOptions(_parentView.bounds.size, YES, [[UIScreen mainScreen] scale]);
    [_parentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView * viewImage = [[UIImageView alloc] initWithImage:image];
    [_overlay addSubview:viewImage];
    [_overlay removeFromSuperview];
    [_parentView addSubview:_overlay];
    
    //添加遮罩：
    [_maskView removeFromSuperview];
    [_parentView addSubview:_maskView];
    
    //执行动画
    [viewImage.layer addAnimation:[self animationGroupForward:YES] forKey:@"pushedBackAnimation"];
    
    //添加action sheet
    [self removeFromSuperview];
    [_parentView addSubview:self];
    
    [UIView animateWithDuration:EZ_ANIMATION_DURATION
                     animations:^{
                         _maskView.alpha = 0.5f;
                         self.frame = changeF;
                     }completion:^(BOOL finished){
                         [_maskView removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
                         [_maskView addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
                     }];
    
}

- (void)dismissActionSheetFromView:(UIView *)view
{
    [_maskView removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:EZ_ANIMATION_DURATION animations:^{
        self.frame = CGRectMake(0, _parentView.frame.size.height, self.width, self.height);
    } completion:^(BOOL finished) {
        [_overlay removeFromSuperview];
        [self removeFromSuperview];
    }];
    
    // Begin overlay animation
    UIImageView * viewImage = (UIImageView*)[_overlay.subviews objectAtIndex:0];
    [viewImage.layer addAnimation:[self animationGroupForward:NO] forKey:@"bringForwardAnimation"];
    
    [UIView animateWithDuration:EZ_ANIMATION_DURATION animations:^{
        _maskView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [viewImage removeFromSuperview];
    }];
}

- (CAAnimationGroup*)animationGroupForward:(BOOL)_forward
{
    //执行动画
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-800;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1 = CATransform3DRotate(t1, 15.0f*M_PI/180.0f, 1, 0, 0);
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = t1.m34;
    t2 = CATransform3DTranslate(t2, 0, _parentView.frame.size.height*-0.08, 0);
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:t1];
    animation.duration =EZ_ANIMATION_DURATION/2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.toValue = [NSValue valueWithCATransform3D:(_forward?t2:CATransform3DIdentity)];
    animation2.beginTime = animation.duration;
    animation2.duration = animation.duration;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setDuration:animation.duration*2];
    [group setAnimations:[NSArray arrayWithObjects:animation,animation2, nil]];
    return group;
}

#pragma mark- action
- (void)cancel:(id)sender
{
    [self dismissActionSheetFromView:nil];
    [_delegate cancelButtonSelected];
}

- (void)go:(id)sender
{
    [self dismissActionSheetFromView:nil];
    [_delegate goButtonSelected];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
