//
//  HsCustomSegmentViewController.m
//  TZYJ_IPhone
//
//  Created by wyj wu on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomSegmentViewController.h"

@implementation CustomSegmentViewController
@synthesize clickdelegate = _clickdelegate;

//- (void)dealloc
//{
//    [_items release];
//    [super  dealloc];
//}

- (void)segmentTouchDown:(id)sender
{
//    do nothing
}

- (void)segmentTouchCancel:(id)sender
{
//    do nothing
}

- (void)segmentTouchUp:(id)sender
{
    if (_focusIndex != ((UIButton*)sender).tag)
    {
        int iNewCurrent = ((UIButton*)sender).tag;
        UIButton *btnSelected = (UIButton*)[self viewWithTag:iNewCurrent];
        UIButton *btnAnother = (UIButton*)[self viewWithTag:_focusIndex];
        UIImage *imgSelected = nil;
        UIImage *imgNormal = [UIImage imageNamed:@"home-tab-default"];
        if (iNewCurrent == 1)
            imgSelected = [UIImage imageNamed:@"home-tab-left-highlight"];
        else
            imgSelected = [UIImage imageNamed:@"home-tab-right-highlight"];
        
        [btnSelected setBackgroundImage:imgSelected forState:UIControlStateSelected];
        [btnSelected setBackgroundImage:imgSelected forState:UIControlStateNormal];
        [btnSelected setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [btnSelected setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [btnAnother setBackgroundImage:imgNormal forState:UIControlStateSelected];
        [btnAnother setBackgroundImage:imgNormal forState:UIControlStateNormal];
        [btnAnother setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btnAnother setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        if ([_clickdelegate respondsToSelector: @selector(didSelectWithItem:)]) {
            
            [_clickdelegate didSelectWithItem:((UIButton*)sender).tag];
        }
        
        _focusIndex = ((UIButton*)sender).tag;
    }

}


- (UIButton*)createSegmentButtonByFrame:(CGRect)frame name:(NSString*)titleName index:(int)selectIndex
{
    UIButton *segBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    
    segBtn.highlighted = NO;
    
    segBtn.adjustsImageWhenHighlighted = NO;
    
    if (_focusIndex == selectIndex + 1) {
        if (_focusIndex == 1) {
            [segBtn setBackgroundImage:[UIImage imageNamed:@"home-tab-left-highlight"] forState:UIControlStateSelected];
            [segBtn setBackgroundImage:[UIImage imageNamed:@"home-tab-left-highlight"] forState:UIControlStateNormal];
            [segBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [segBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        else
        {
            [segBtn setBackgroundImage:[UIImage imageNamed:@"home-tab-right-highlight"] forState:UIControlStateSelected];
            [segBtn setBackgroundImage:[UIImage imageNamed:@"home-tab-right-highlight"] forState:UIControlStateNormal];
            [segBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [segBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
    }
    else{
        [segBtn setBackgroundImage:[UIImage imageNamed:@"home-tab-default"] forState:UIControlStateSelected];
        [segBtn setBackgroundImage:[UIImage imageNamed:@"home-tab-default"] forState:UIControlStateNormal];
        [segBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [segBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    

//    [segBtn setBackgroundImage:[UIImage imageNamed:@"home-tab-focus-image"] forState:UIControlStateHighlighted];
    
    segBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    
    [segBtn setTitle:titleName forState:UIControlStateNormal];
    
    segBtn.tag = selectIndex + 1;

    [segBtn addTarget:self action:@selector(segmentTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [segBtn addTarget:self action:@selector(segmentTouchCancel:) forControlEvents:UIControlEventTouchUpOutside];
    [segBtn addTarget:self action:@selector(segmentTouchDown:) forControlEvents:UIControlEventTouchDown];
    
    return segBtn;

}
- (id)initWithItems:(NSArray*)items viewFrame:(CGRect)viewFrame ctrStyle:(UISegmentedControlStyle)ctrStyle focusIndex:(int)index;
{
    self = [super initWithFrame:viewFrame];
    if (self) {
        
        _focusIndex = index;
        
        self.segmentedControlStyle = ctrStyle;
        self.contentMode  = UIViewContentModeCenter;
        int avgWidth = 320/[items count];
        int startX = 0;
        
        for (int i = 0;  i < [items count]; i++) {
            [self insertSubview:[self createSegmentButtonByFrame:CGRectMake(startX, 0, avgWidth, 30) name:[items objectAtIndex:i] index:i] atIndex:i];
            startX += avgWidth;
        }
        
        ((UIButton*)[self viewWithTag:1]).selected = YES;
        
    }
    
    return self;
}


- (void)setAccessibilityLabel:(int)index localizedString:(NSString*)localizedString{
   [[self imageForSegmentAtIndex:index] setAccessibilityLabel:localizedString];
}
@end
