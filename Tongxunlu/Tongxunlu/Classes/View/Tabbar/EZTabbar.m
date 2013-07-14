//
//  EZTabbar.m
//  Tongxunlu
//
//  Created by kongkong on 13-6-11.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "EZTabbar.h"

typedef enum ShowStatus{
    SHOWUP,
    PULLDOWN
}TabBarShowStatus;

@interface EZTabbar()

///< viewcontroller容器
@property(nonatomic,retain)NSMutableArray*  _items;
@property(nonatomic,assign)NSUInteger       _selectedIndex;

@property(nonatomic,assign)TabBarShowStatus _showStatus;
@property(nonatomic,retain)UIImageView*     _selectedImageView;

@property(nonatomic,retain)UIView*          _barPanel;
@property(nonatomic,retain)UIControl*       _showUpView;

-(void)resizeSelectImageView;

@end

@implementation EZTabbar

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        /// showup & pull down
        self._showStatus = SHOWUP;
        
        self._showUpView = [[UIControl alloc]initWithFrame:CGRectMake(0, self.height, self.width, 26)];
        
        [self addSubview:self._showUpView];
        
        [self._showUpView addTarget:self action:@selector(showUp) forControlEvents:UIControlEventTouchUpInside];
        /// bar panel
        self._barPanel = [[UIView alloc]initWithFrame:self.bounds];
        
        self._barPanel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self._barPanel];
        
        /// items
        self._items = [[NSMutableArray alloc]initWithCapacity:4];
        
        self._selectedImageView = [[UIImageView alloc]initWithFrame:frame];
        
        self._selectedImageView.clipsToBounds = NO;
        
        [self._barPanel addSubview:self._selectedImageView];
        
        self._selectedIndex = 0;
    }
    
    return self;
}

-(id)init{
    return [self initWithFrame:CGRectMake(0, SCREEN_HEIGHT-EZTABBARITEM_HEIGHT-STATUSBAR_HEIGHT, 320, EZTABBARITEM_HEIGHT)];
}

-(id)initWithDelegate:(id<EZTabBarDelegate>)delegate{
    self = [self init];
    
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}

-(void)setBackgroundImage:(NSString *)backgroundImage{
    
    self._barPanel.backgroundColor = [UIColor colorWithPatternImage:[UIImage themeImageNamed:backgroundImage]];
}

-(void)setSelectedBackgroundImage:(NSString *)selectedBackgroundImage{
    self._selectedImageView.image = [UIImage themeImageNamed:selectedBackgroundImage];
}

-(void)resizeSelectImageView{
    if ([self._items count] == 0) {
        return;
    }
    
    self._selectedImageView.width = self.width/[self._items count];
    self._selectedImageView.height = self.height;
}

-(NSUInteger)currentIndex{
    return self._selectedIndex;
}

- (void)selectItemAtIndex:(NSInteger)index
{
    if (index < self._items.count) {
        [self tabBarItemdidSelected:self._items[index]];
    }
    
}

#pragma -mark
#pragma -mark reload data

-(void)loadData{
    if ([self._items count] > 0) {
        return;
    }
    
    NSUInteger barNum = 0;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfBars)]) {
        barNum = [self.delegate numberOfBars];
    }
    
    if (0 == barNum || ![self.delegate respondsToSelector:@selector(tabBar:itemAtIndex:)]) {
        return;
    }
    
    CGFloat width = self.width / barNum;
    CGFloat xOffset = 0.0f;
    
    
    for (short index = 0; index < barNum; ++index) {
        EZTabbarItem* item = [self.delegate tabBar:self itemAtIndex:index];
        
        if (item) {
            item.left = xOffset;
            
            item.delegate = self;
            
            [self._items addObject:item];
            
            //            [self addSubview:item];
            [self._barPanel addSubview:item];
            
            if (index == 0) {
                item.selected = YES;
                
                self._selectedImageView.frame = item.frame;
            }
            
            item.tag = -index;
            
            /// 选中动画
            item.selectedAnimationBlock = ^(void){
                self._selectedImageView.left = xOffset;
            };
            
        }
        xOffset += width;
    }
    self._selectedIndex = 0;
}

#pragma -mark
#pragma -mark tabbar item delegate
-(void)tabBarItemdidSelected:(EZTabbarItem *)item{
    
    NSUInteger index = -item.tag;
    
    if (index >= [self._items count]) {
        DBG(@"tabbar 异常，越界");
        
        return;
    }
    
//    if (self._selectedIndex == index) {
//        return;
//    }
    
    if ([self.delegate respondsToSelector:@selector(shouldLoadBarAtIndex:)]) {
        if (![self.delegate shouldLoadBarAtIndex:index]) {
            return;
        }
    }
    
    
    EZTabbarItem* old = [self._items objectAtIndex:self._selectedIndex];
    
    if (old) {
        old.selected = NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:selectAtIndex:)]) {
        [self.delegate tabBar:self selectAtIndex:index];
    }
    
    self._selectedIndex = index;
    
    item.selected = YES;
}

-(EZTabbarItem*)itemAtIndex:(NSUInteger)index{
    if (index < [self._items count]) {
        return [self._items objectAtIndex:index];
    }
    
    return nil;
}
#pragma -mark
#pragma -mark pull down & showup

-(void)setShowUpImage:(NSString *)image{
    
    if (isEmptyStr(image)) {
        return;
    }
    
    self._showUpView.backgroundColor = [UIColor colorWithPatternImage:[UIImage themeImageNamed:image]];
}

-(void)pullDown{
    if (PULLDOWN == self._showStatus) {
        return;
    }
    
    self._showStatus = PULLDOWN;
    
    [UIView animateWithDuration:EZTABBAR_ANIMATION_DURTION animations:^{
        self._barPanel.top = self.height;
        self._showUpView.bottom = self.height;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)showUp{
    if (SHOWUP == self._showStatus) {
        return;
    }
    
    self._showStatus = SHOWUP;
    [UIView animateWithDuration:EZTABBAR_ANIMATION_DURTION animations:^{
        self._barPanel.top = 0;
        self._showUpView.top = self.height;
    }];
}

@end
