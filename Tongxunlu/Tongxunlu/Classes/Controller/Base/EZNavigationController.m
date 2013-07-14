//
//  EZNavigationController.m
//  Tongxunlu
//
//  Created by kongkong on 13-6-11.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "EZNavigationController.h"

@interface EZNavigationController (){
    UIView *_maskingView;
}
@end

@implementation EZNavigationController

- (id)init
{
    self = [super init];
    if (self) {
        if (nil == _viewControllers) {
            _viewControllers = [NSMutableArray array];
        } else {
            [_viewControllers removeAllObjects];
        }
    }
    return self;
}

- (id)initWithRootViewController:(EZRootViewController *)rootViewController {
    
    self = [self initWithRootViewController:rootViewController defaultFrame:FULL_VIEW_FRAME];
    
    return self;
}

- (id)initWithRootViewController:(EZRootViewController *)rootViewController defaultFrame:(CGRect)frame{
    self = [super init];
    
    if (self) {
        
        self.defaultFrame = frame;
        
        if (nil == _viewControllers) {
            _viewControllers = [[NSMutableArray alloc] initWithObjects:rootViewController, nil];
        } else {
            [_viewControllers removeAllObjects];
            [_viewControllers addObject:rootViewController];
        }
        
        rootViewController.defaultFrame = CGRectMake(0, 0, frame.size.width, frame.size.height); ///CONTENT_VIEW_FRAME;
        
        rootViewController.ezNavigationController = self;
        
        self.ezTabbarController = rootViewController.ezTabbarController;
        [self.view addSubview:rootViewController.view];
        
        _rootViewController = rootViewController;
        _topViewController = rootViewController;
    }
    
    return self;
}

#pragma mark - push view controller

- (void)pushViewController:(EZRootViewController *)viewController {
    [self pushViewController:viewController withAnimation:PageTransitionHorizontal];
}

- (void)pushViewController:(EZRootViewController *)viewController withAnimation:(PageTransitionType)animation {
    EZRootViewController *oldViewController = [_viewControllers lastObject];
    
    if (!viewController) {
        return;
    }
    
    [_viewControllers addObject:viewController];
    viewController.animationType = animation;
    viewController.ezNavigationController = self;
    
    if (None != animation) {
        if (nil == _maskingView) {
            _maskingView = [[UIView alloc] initWithFrame:self.view.bounds];
            _maskingView.backgroundColor = [UIColor blackColor];
            _maskingView.alpha = 0;
            [self.view addSubview:_maskingView];
        } else {
            _maskingView.alpha = 0;
            [self.view bringSubviewToFront:_maskingView];
        }
        
        switch (animation) {
                /// 水平进入的时候，需要一个左右扫动手势切换回前一个页面
            case PageTransitionHorizontal:{
                viewController.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:viewController action:@selector(back)];
             
                viewController.swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
                
                [viewController.view addGestureRecognizer:viewController.swipeGestureRecognizer];
                
                [self pushViewController:viewController oldViewController:oldViewController withSlideDirection:@"horizontal"];
            }
                break;
            case PageTransitionVertical:{
                [self pushViewController:viewController oldViewController:oldViewController withSlideDirection:@"vertical"];
            }
                break;
            default:
                break;
        }
    } else {
        [self.view addSubview:viewController.view];
        oldViewController.view.hidden = YES;
    }
    
    _topViewController = viewController;
    [_topViewController viewWillAppear:NO];
    [oldViewController viewWillDisappear:NO];
}

- (void)pushViewController:(EZRootViewController *)viewController oldViewController:(EZRootViewController *)oldViewController withSlideDirection:(NSString *)direction {
    
    CGRect originalRect = CGRectMake(0, 0, viewController.view.width, viewController.view.height);
    
    if (CGRectIsEmpty(viewController.defaultFrame)) {
        viewController.defaultFrame = CONTENT_VIEW_FRAME;
        viewController.showNavigationBar = YES;
        
        if (viewController != _topViewController) {
            
            [viewController setLeftbarItem:[UIButton backButtonWithTarget:viewController action:@selector(back)]];
        }
        
        
        originalRect = self.defaultFrame;
    }
    
    CGRect tempRect = CGRectZero;
    
    if ([@"horizontal" isEqualToString:direction]) {
        tempRect = CGRectMake(originalRect.origin.x + originalRect.size.width, originalRect.origin.y, originalRect.size.width, originalRect.size.height);
    } else if ([@"vertical" isEqualToString:direction]) {
        tempRect = CGRectMake(originalRect.origin.x, originalRect.origin.y + originalRect.size.height, originalRect.size.width, originalRect.size.height);
    }
    
    viewController.view.frame = tempRect;
    
    [self.view addSubview:viewController.view];
    
    oldViewController.view.clipsToBounds = YES;
    
    [UIView animateWithDuration:EZ_ANIMATION_DURATION
                     animations:^{
                         CGAffineTransform transform = CGAffineTransformMakeScale(0.97, 0.97);
                         [oldViewController.view setTransform:transform];
                         
                         viewController.view.frame = originalRect;
                         _maskingView.alpha = 1;
                     } completion:^(BOOL finished){                         
                     }];
}

#pragma mark - pop view controller

- (EZRootViewController *)popViewController {
    return [self popViewControllerWithAnimation:None];
}

- (EZRootViewController *)popViewControllerWithAnimation:(PageTransitionType)animation {
    NSInteger viewControllerCount = [_viewControllers count];
    EZRootViewController *popedViewController = [_viewControllers lastObject];
    
    if (viewControllerCount > 1) {
        if (None != animation) {
            [_viewControllers removeObject:popedViewController];
            _topViewController = [_viewControllers lastObject];
            _topViewController.view.hidden = NO;
            switch (animation) {
                case PageTransitionHorizontal:
                    [self slidePopViewController:popedViewController withDirection:@"horizontal"];
                    break;
                case PageTransitionVertical:
                    [self slidePopViewController:popedViewController withDirection:@"vertical"];
                    break;
                default:
                    break;
            }
        } else {
            popedViewController = [self releaseViewController:[_viewControllers lastObject]];
        }
        
        [_topViewController viewWillAppear:NO];
        
        return popedViewController;
    }
    
    return nil;
}

- (void)slidePopViewController:(EZRootViewController *)popedViewController withDirection:(NSString *)direction {
    CGRect originalRect = CGRectMake(0, 0, popedViewController.view.width, popedViewController.view.height);
    CGRect tempRect;
    
    if ([@"horizontal" isEqualToString:direction]) {
        tempRect = CGRectMake(originalRect.origin.x + originalRect.size.width, originalRect.origin.y, originalRect.size.width, originalRect.size.height);
    } else if ([@"vertical" isEqualToString:direction]) {
        tempRect = CGRectMake(originalRect.origin.x, originalRect.origin.y + originalRect.size.height, originalRect.size.width, originalRect.size.height);
    }
    
    popedViewController.view.frame = originalRect;
    [UIView animateWithDuration:EZ_ANIMATION_DURATION
                     animations:^{
                         CGAffineTransform transform = CGAffineTransformMakeScale(1, 1);
                         [_topViewController.view setTransform:transform];
                         
                         popedViewController.view.frame = tempRect;
                         _maskingView.alpha = 0;
                         
                     }
                     completion:^(BOOL finished) {
                         
                         _topViewController.view.clipsToBounds = NO;
                         popedViewController.view.hidden = YES;
                         for (UIView *subView in popedViewController.view.subviews) {
                             [subView removeFromSuperview];
                         }
                         [popedViewController.view removeFromSuperview];
                         
                         [popedViewController viewDidUnload];
                         
                         [self.view bringSubviewToFront:_topViewController.view];
                         _maskingView.alpha = 1;
                     }];
}

- (void)popToViewController:(EZRootViewController *)viewController animated:(BOOL)animated {
    if ([_viewControllers containsObject:viewController]) {
        EZRootViewController *presentViewController = [_viewControllers objectAtIndex:[_viewControllers count] - 2];
        while (![presentViewController isEqual:viewController]) {
            NSInteger viewControllerCount = [_viewControllers count];
            [self releaseViewController:[_viewControllers objectAtIndex:viewControllerCount - 2]];
            presentViewController = [_viewControllers objectAtIndex:[_viewControllers count] - 2];
        }
    }
    if (animated) {
        [self popViewControllerWithAnimation:_topViewController.animationType];
    }else {
        [self popViewController];
    }
}

- (void)popToRootViewControllerAnimated:(BOOL)animated {
    EZRootViewController *presentViewController = [_viewControllers objectAtIndex:[_viewControllers count] - 2];
    while (![presentViewController isEqual:[_viewControllers objectAtIndex:0]]) {
        NSInteger viewControllerCount = [_viewControllers count];
        [self releaseViewController:[_viewControllers objectAtIndex:viewControllerCount - 2]];
        presentViewController = [_viewControllers objectAtIndex:[_viewControllers count] - 2];
    }
    if (animated) {
        [self popViewControllerWithAnimation:_topViewController.animationType];
    }else {
        [self popViewController];
    }
}

- (EZRootViewController *)releaseViewController:(EZRootViewController *)viewController {
    viewController.view.hidden = YES;
    for (UIView *subView in viewController.view.subviews) {
        [subView removeFromSuperview];
    }
    [viewController.view removeFromSuperview];
    
    [_viewControllers removeObject:viewController];
    [viewController viewDidUnload];
    
    return viewController;
}



@end
