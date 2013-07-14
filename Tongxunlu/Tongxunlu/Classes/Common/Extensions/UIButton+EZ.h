//
//  UIButton+EZ.h
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EZ)
/// navigation bar item

/**
 * back button
 */
+ (UIButton *)backButtonWithTarget:(id)target action:(SEL)action;

/**
 * barButton
 */
+ (UIButton *)barButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;

/**
 * left button
 */
+ (UIButton *)leftBarButtonWithImage:(UIImage*)image highlightedImage:(UIImage*)highlightedImage target:(id)target action:(SEL)action;

/**
 * right button
 */
+ (UIButton *)rightBarButtonWithImage:(UIImage*)image highlightedImage:(UIImage*)highlightedImage target:(id)target action:(SEL)action;

/**
 * keyboard button
 */
+ (UIButton *)buttonWithImage:(UIImage*)image backgroundImage:(UIImage*)backgroundImage highlightedBackgroundImage:(UIImage*)highlightedBackgroundImage target:(id)target action:(SEL)action;

+ (UIButton *)buttonWithTitle:(NSString *)title image:(UIImage*)image highlightedImage:(UIImage*)highlightedImage target:(id)target action:(SEL)action;

+ (UIButton *)blackButtonWithTitle:(NSString *)title image:(UIImage*)image highlightedImage:(UIImage*)highlightedImage target:(id)target action:(SEL)action;

+ (UIButton *)redButtonWithTitle:(NSString *)title image:(UIImage*)image highlightedImage:(UIImage*)highlightedImage target:(id)target action:(SEL)action;
@end
