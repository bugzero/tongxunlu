//
//  EZTabbarItem.h
//  Tongxunlu
//
//  Created by kongkong on 13-6-11.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedAnimation)(void);
typedef void(^DisSelectedAnimation)(void);

#define EZTABBAR_ANIMATION_DURTION 0.3

#define EZTABBARITEM_HEIGHT 49
#define EZTABBAR_ITEM_WIDTH 80

@class EZTabbarItem;

typedef void(^TabbarItemClickBlock)(EZTabbarItem* item);

@protocol EZTabBarItemDelegate;

@interface EZTabbarItem : UIControl

@property(nonatomic,assign)id<EZTabBarItemDelegate>delegate;
@property(nonatomic,copy)TabbarItemClickBlock   clickBlock;

@property(nonatomic,copy)SelectedAnimation      selectedAnimationBlock;  ///< 此item被选中需要做的动画
@property(nonatomic,copy)DisSelectedAnimation   disSelectedAnimationBlock;

/**
 * @brief   初始化组件，创建一个固定高度（45）的item
 * @param   title 标题 icon 默认显示图片  selectedIcon 选中图片
 */
-(id)initWithTitle:(NSString*)title icon:(UIImage *)icon selectedIcon:(UIImage*)selectedIcon;

-(void)setIcon:(UIImage*)image;

-(void)setSelectedIcon:(UIImage*)selectedIcon;

-(void)setTitle:(NSString*)title;

@end

@protocol EZTabBarItemDelegate <NSObject>

@optional
-(void)tabBarItemdidSelected:(EZTabbarItem*)item;

@end