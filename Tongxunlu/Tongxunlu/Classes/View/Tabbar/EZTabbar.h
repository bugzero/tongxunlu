//
//  EZTabbar.h
//  Tongxunlu
//
//  Created by kongkong on 13-6-11.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZTabbarItem.h"

@protocol EZTabBarDelegate;

@interface EZTabbar : UIView<EZTabBarItemDelegate>

@property(nonatomic,retain)id<EZTabBarDelegate> delegate;

-(id)initWithDelegate:(id<EZTabBarDelegate>)delegate;

-(void)loadData;

-(void)setBackgroundImage:(NSString *)backgroundImage;

-(void)setSelectedBackgroundImage:(NSString *)selectedBackgroundImage;

-(void)setShowUpImage:(NSString*)image;

-(NSUInteger)currentIndex;

-(void)pullDown;

-(void)showUp;

-(void)selectItemAtIndex:(NSInteger)index;

-(EZTabbarItem*)itemAtIndex:(NSUInteger)index;
@end

@protocol EZTabBarDelegate <NSObject>

-(EZTabbarItem*)tabBar:(EZTabbar*)tabBar itemAtIndex:(NSUInteger)index;

-(NSUInteger)numberOfBars;

@optional
-(void)tabBar:(EZTabbar*)tabBar selectAtIndex:(NSUInteger)index;

-(BOOL)shouldLoadBarAtIndex:(NSUInteger)index;

@end