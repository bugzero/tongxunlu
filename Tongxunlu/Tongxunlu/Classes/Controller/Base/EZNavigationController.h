//
//  EZNavigationController.h
//  Tongxunlu
//
//  Created by kongkong on 13-6-11.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZNavigationController : EZRootViewController{
    EZRootViewController*       _rootViewController;
    EZRootViewController*       _topViewController;
    NSMutableArray*             _viewControllers;
}

// push the root view controller without animation.
- (id)initWithRootViewController:(EZRootViewController *)rootViewController;

- (id)initWithRootViewController:(EZRootViewController *)rootViewController defaultFrame:(CGRect)frame;

// Has no effect if the view controller is already in the stack.
- (void)pushViewController:(EZRootViewController *)viewController;

// Push the view controller with a animation.
- (void)pushViewController:(EZRootViewController *)viewController withAnimation:(PageTransitionType)animation;

// Returns the popped controller.
- (EZRootViewController *)popViewController;

- (EZRootViewController *)popViewControllerWithAnimation:(PageTransitionType)animation;

// Pops view controllers until the one specified is on top.
- (void)popToViewController:(EZRootViewController *)viewController animated:(BOOL)animated;

// Pops until there's only a single view controller left on the stack.
- (void)popToRootViewControllerAnimated:(BOOL)animated;

@end
