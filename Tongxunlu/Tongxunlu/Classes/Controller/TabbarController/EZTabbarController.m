//
//  EZTabbarController.m
//  Tongxunlu
//
//  Created by kongkong on 13-6-11.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "EZTabbarController.h"
#import "EZNavigationController.h"

@interface EZTabbarController()
@property(nonatomic,retain)NSMutableArray*  _viewControllers;
@property(nonatomic,assign)NSUInteger   numberOfItems;
@end

@implementation EZTabbarController

-(id)init{
    self = [super init];
    
    if (self) {
        self.numberOfItems = 4;
        self._viewControllers = [[NSMutableArray alloc]initWithCapacity:self.numberOfItems];
        for (short i = 0 ; i < self.numberOfItems; ++i) {
            NSObject* obj = [[NSObject alloc]init];
            
            [self._viewControllers addObject:obj];
        }
    }
    
    return self;
}

-(id)initWithDelegate:(id<EZTabbarControllerDlegate>)delegate{
    self = [super init];
    
    if (self) {
        self.delegte = delegate;
        
        self.numberOfItems = [self.delegte numberOfTabbarItems];
        self._viewControllers = [[NSMutableArray alloc]initWithCapacity:self.numberOfItems];
        for (short i = 0 ; i < self.numberOfItems; ++i) {
            NSObject* obj = [[NSObject alloc]init];
            
            [self._viewControllers addObject:obj];
        }
    }
    
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, FULL_WIDTH, FULL_HEIGHT);
    
    self.view.backgroundColor = [UIColor clearColor];
    
    /// create tabbar
    self.tabBar = [[EZTabbar alloc]initWithDelegate:self];
    
    [self.tabBar setBackgroundImage:@"TabBar.png"];
    [self.tabBar setSelectedBackgroundImage:@"TabButtonBgImage"];
    [self.tabBar setShowUpImage:@"tabbar_bg_showup"];
    
    [self.tabBar loadData];
    
    if (self.delegte && [self.delegte respondsToSelector:@selector(viewControllerAtIndex:)]) {
        EZRootViewController* vctl = [self.delegte viewControllerAtIndex:self.tabBar.currentIndex];
        
        [self._viewControllers replaceObjectAtIndex:0 withObject:vctl];
        
        vctl.view.frame = CGRectMake(0, 0, FULL_WIDTH, FULL_HEIGHT-EZTABBARITEM_HEIGHT);
        
        [self.view addSubview:vctl.view];
    }
    
    [self.view addSubview:self.tabBar];
}
-(EZNavigationController*)currentNavigationViewController{
    EZRootViewController * viewController = [self currentViewController];
    if ([viewController isKindOfClass:[EZNavigationController class]]) {
        return (EZNavigationController*)viewController;
    }
    else
        return nil;
}

-(EZRootViewController*)currentViewController{
    NSUInteger index = [self.tabBar currentIndex];
    
    if (index < [self._viewControllers count]) {
        return [self._viewControllers objectAtIndex:index];
    }
    return nil;
}

#pragma -mark
#pragma -mark delegate

-(NSUInteger)numberOfBars{
    return self.numberOfItems;
}

-(EZTabbarItem *)tabBar:(EZTabbar *)tabBar itemAtIndex:(NSUInteger)index{
    
    EZTabbarItem* item = nil;
    
    if (self.delegte && [self.delegte respondsToSelector:@selector(tabBarController:itemAtIndex:)]) {
        return [self.delegte tabBarController:self itemAtIndex:index];
    }
    
    return item;
}

-(void)tabBar:(EZTabbar *)tabBar selectAtIndex:(NSUInteger)index{
    if (index >= [self._viewControllers count]) {
        return;
    }
    
    
    if ([self.delegte respondsToSelector:@selector(tabbar:didSelectedAtIndex:tabbarItem:)]) {
        [self.delegte tabbar:tabBar didSelectedAtIndex:index tabbarItem:[tabBar itemAtIndex:index]];
    }
    
    if (index == self.tabBar.currentIndex) {
        return;
    }
    
    if ([self.delegte respondsToSelector:@selector(shouldLoadTabBarAtIndex:)]) {
        if (![self.delegte shouldLoadTabBarAtIndex:index]) {
            return;
        }
    }
    
    id item = [self._viewControllers objectAtIndex:index];
    
    EZRootViewController* vctl = nil;
    /// 第一次点击
    if (![item isKindOfClass:[EZRootViewController class]]) {
        
        if (self.delegte && [self.delegte respondsToSelector:@selector(viewControllerAtIndex:)]) {
            vctl = [self.delegte viewControllerAtIndex:index];
        }
        
        if (vctl) {
            [self._viewControllers replaceObjectAtIndex:index withObject:vctl];
        }
    }
    else{
        vctl = item;
    }
    /// 切换ViewCtl
    if (vctl) {
        id currentVctl = [self._viewControllers objectAtIndex:self.tabBar.currentIndex];
        
        if ([currentVctl isKindOfClass:[EZRootViewController class]]) {
            
            [((EZRootViewController*)currentVctl).view removeFromSuperview];
        }
        
        [self.view addSubview:vctl.view];
    }
    
    [self.view bringSubviewToFront:self.tabBar];
}

- (void)showTabBar
{
    self.tabBar.hidden = NO;
}

- (void)hideTabBar
{
    self.tabBar.hidden = YES;
}

-(void)pullDownBar{
    [self.tabBar pullDown];
}

-(void)showUpBar{
    [self.tabBar showUp];
}

-(BOOL)shouldLoadBarAtIndex:(NSUInteger)index{
    if ([self.delegte respondsToSelector:@selector(shouldLoadTabBarAtIndex:)]) {
        return [self.delegte shouldLoadTabBarAtIndex:index];
    }
    
    return YES;
}


@end