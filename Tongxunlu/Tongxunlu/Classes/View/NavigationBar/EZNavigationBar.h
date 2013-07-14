//
//  EZNavigationBar.h
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZNavigationBar : UIView

@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)UIView *titleView;

@property (nonatomic, strong)UIView *leftBarButton;
@property (nonatomic, strong)UIView *rightBarButton;

- (void)addShadow;
- (void)removeShadow;

- (void)setTitleColor:(UIColor*)color;

@end
