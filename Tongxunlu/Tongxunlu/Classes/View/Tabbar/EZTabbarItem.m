//
//  EZTabbarItem.m
//  Tongxunlu
//
//  Created by kongkong on 13-6-11.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "EZTabbarItem.h"

#define TABBAR_ITEM_SPAN_TOP    6
#define TABBAR_ITEM_SPAN_BOTTOM 3

@interface EZTabbarItem()

@property(nonatomic,retain)UIImage*     _icon;
@property(nonatomic,retain)UIImage*     _selectedIcon;
@property(nonatomic,retain)UILabel*     _label;
@property(nonatomic,retain)UIImageView* _imageView;

-(void)_didSelect;

@end


@implementation EZTabbarItem


-(id)initWithTitle:(NSString *)title icon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon{
    self = [super initWithFrame:CGRectMake(0, 0, EZTABBAR_ITEM_WIDTH, EZTABBARITEM_HEIGHT)];
    
    if (self) {
        self.selected = NO;
        
        self._icon = icon;
        self._selectedIcon = selectedIcon;
        
        self._label = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, EZTABBAR_ITEM_WIDTH,EZTABBARITEM_HEIGHT-30)];
        self._label.backgroundColor = [UIColor clearColor];
        self._label.textColor = [UIColor whiteColor];
        self._label.textAlignment = UITextAlignmentCenter;
        self._label.userInteractionEnabled = NO;
        self._label.text = title;
        self._label.font = FONT(12);
        [self addSubview:self._label];
        
        self._imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, EZTABBAR_ITEM_WIDTH,30)];
        self._imageView.image = self._icon;
        self._imageView.userInteractionEnabled = NO;
        [self addSubview:self._imageView];
        
        [self addTarget:self action:@selector(_didSelect) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setIcon:(UIImage *)image{
    if (!image) {
        return;
    }
    self._icon = image;
    
    if (!self.selected) {
        self._imageView.image = image;
    }
}

-(void)setSelectedIcon:(UIImage *)selectedIcon{
    if (!selectedIcon) {
        return;
    }
    self._selectedIcon = selectedIcon;
    
    if (self.selected) {
        self._imageView.image = selectedIcon;
    }
}

-(void)setTitle:(NSString*)title{
    if (!title) {
        return;
    }
    self._label.text = title;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    self._label.frame = CGRectMake(0, 0, self.width, self.height/4);
    self._label.bottom = self.bottom-TABBAR_ITEM_SPAN_BOTTOM;
    
    CGFloat imageWidth = self.width;
    CGFloat imageHeight = self.height/4*3-(TABBAR_ITEM_SPAN_BOTTOM+TABBAR_ITEM_SPAN_TOP);
    
    if (self._icon) {
        imageWidth = self._icon.size.width;
        if (imageWidth > 0) {
            imageWidth = self._icon.size.width/self._icon.size.height*imageHeight;
        }
    }
    
    self._imageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
    self._imageView.bottom = self._label.top-1;
    self._imageView.centerX = self.centerX-self.left;
}

#pragma -mark
#pragma -mark action

-(void)_didSelect{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarItemdidSelected:)]) {
        [self.delegate tabBarItemdidSelected:self];
    }
    
    if (self.clickBlock) {
        self.clickBlock(self);
    }
}

-(void)setSelected:(BOOL)selected{
    
    if (selected == self.selected) {
        return;
    }
    
    super.selected = selected;
    
    CGFloat span = 0;///TABBAR_ITEM_SPAN_BOTTOM;
    
    if (!selected) {
        [UIView animateWithDuration:EZTABBAR_ANIMATION_DURTION animations:^{
            self._imageView.image = self._icon;
            
            self._label.bottom = self.bottom-TABBAR_ITEM_SPAN_BOTTOM;
            self._imageView.bottom = self._label.top-1;
            
            if (self.disSelectedAnimationBlock) {
                self.disSelectedAnimationBlock();
            }
            
        }];
    }
    else{
        [UIView animateWithDuration:EZTABBAR_ANIMATION_DURTION animations:^{
            self._imageView.image = self._selectedIcon;
            
            self._imageView.top -= span;
            self._label.top -= span;
            
            if (self.selectedAnimationBlock) {
                self.selectedAnimationBlock();
            }
        }];
    }
}

@end
