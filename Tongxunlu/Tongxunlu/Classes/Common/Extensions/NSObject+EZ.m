//
//  NSObject+EZ.m
//  Tongxunlu
//
//  Created by 吴英杰 on 13-6-23.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "NSObject+EZ.h"
#import <objc/runtime.h>
@implementation NSObject (EZ)

@dynamic noticeView;

static char* noticeViewKey = "NoticeViewKey";
-(MBProgressHUD *)noticeView{
    return objc_getAssociatedObject(self, noticeViewKey);
}

-(void)setNoticeView:(MBProgressHUD *)noticeView{
    objc_setAssociatedObject(self, noticeViewKey, noticeView, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - Notice view


- (void)showNotice:(NSString *)notice duration:(NSTimeInterval)duration{
    [self hideNotice];
    
//    UIView* view = [UIApplication sharedApplication].keyWindow;
    UIView * view = ((EZNavigationController*)[EZinstance instanceWithKey:K_NAVIGATIONCTL]).view;
    
	self.noticeView = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:self.noticeView];
	
    self.noticeView.customView = [[UIImageView alloc] initWithImage:nil];
	// Set custom view mode
	self.noticeView.mode = MBProgressHUDModeCustomView;
	
    self.noticeView.yOffset = view.height / 3 - view.height / 2;
    self.noticeView.labelText = notice;
    self.noticeView.margin = 12.f;
	
	[self.noticeView show:YES];
	[self.noticeView hide:YES afterDelay:duration];
}

- (void)showNotice:(NSString *)notice image:(UIImage *)image {
    
    UIView* view = [UIApplication sharedApplication].keyWindow;
    
    [self hideNotice];
    
	self.noticeView = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:self.noticeView];
	
	// Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
	self.noticeView.customView = [[UIImageView alloc] initWithImage:image];
	
	// Set custom view mode
	self.noticeView.mode = MBProgressHUDModeCustomView;
	
    self.noticeView.yOffset = view.height / 3 - view.height / 2;
	self.noticeView.labelText = notice;
    self.noticeView.margin = 12.f;
    
	[self.noticeView show:YES];
	[self.noticeView hide:YES afterDelay:1.5f];
}

- (void)showNotice:(NSString *)notice {
    [self showNotice:notice image:nil];
}


- (void)hideNotice {
    if (nil != self.noticeView) {
        [self.noticeView hide:YES afterDelay:0.f];
    }
}
@end
