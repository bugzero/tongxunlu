//
//  EZTabbarController.h
//  Tongxunlu
//
//  Created by kongkong on 13-6-11.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZTabbar.h"

@protocol EZTabbarControllerDlegate;

@interface EZTabbarController : EZRootViewController<EZTabBarDelegate>

@property(nonatomic,assign)id<EZTabbarControllerDlegate>delegte;
@property(nonatomic,retain)EZTabbar*   tabBar;

-(id)initWithDelegate:(id<EZTabbarControllerDlegate>)delegate;
-(void)pullDownBar;
-(void)showUpBar;
-(void)hideTabBar;
-(void)showTabBar;

-(EZRootViewController*)currentViewController;
-(EZNavigationController*)currentNavigationViewController;
@end

/**
 * protocol
 */
@protocol EZTabbarControllerDlegate <NSObject>

-(EZTabbarItem *)tabBarController:(EZTabbarController *)tabBarCtl itemAtIndex:(NSUInteger)index;

-(NSUInteger)numberOfTabbarItems;
@optional
-(EZRootViewController*)viewControllerAtIndex:(NSUInteger)index;

-(BOOL)shouldLoadTabBarAtIndex:(NSUInteger)index;

-(void)tabbar:(EZTabbar*)tabbar didSelectedAtIndex:(NSUInteger)index tabbarItem:(EZTabbarItem*)item;
@end