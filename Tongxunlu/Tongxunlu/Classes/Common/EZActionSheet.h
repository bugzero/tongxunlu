//
//  EZActionSheet.h
//  Tongxunlu
//
//  Created by kongkong on 13-6-13.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EZActionSheetDelegate;
@interface EZActionSheet : UIView
{
    id<EZActionSheetDelegate> _delegate;
    UIControl *_maskView;
    UIView    *_overlay;
    UIView    *_parentView;
    UIView    *_contentView;
    
    UIButton  *_cancelBtn;
    UIButton  *_goBtn;
}
@property (nonatomic, strong) id<EZActionSheetDelegate> delegate;
- (id)initWithFrame:(CGRect)frame delegate:(id<EZActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle;

- (void)setContent:(UIView *)content;
- (void)showActionSheetFromView:(UIView *)view;
- (void)dismissActionSheetFromView:(UIView *)view;
@end

@protocol EZActionSheetDelegate <NSObject>
@optional
- (void)goButtonSelected;
- (void)cancelButtonSelected;
@end
