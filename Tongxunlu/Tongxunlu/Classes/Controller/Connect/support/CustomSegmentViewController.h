////////////////////////////////////////////////////////////////////////////////
/// CORYRIGHT NOTICE
/// Copyright 2012年 hundsun. All rights reserved.
///
/// @系统名称   投资赢家5.0 IPhone
/// @模块名称   HsCustomSegmentViewController
/// @文件名称   HsCustomSegmentViewController.h
/// @功能说明   自定义分段条
///
/// @软件版本   1.0.0.0
/// @开发人员   wuyj
/// @开发时间   2012-02-23
///
/// @修改记录：最初版本
///
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#define kSegmentedControlHeight 40.0
#define kLeftMargin				20.0
#define kTopMargin				20.0
#define kRightMargin			20.0

@protocol CustomSegmentDelegate <NSObject>

- (void)didSelectWithItem: (int)selectItem;

@end

@interface CustomSegmentViewController : UISegmentedControl
{
    id              _clickdelegate;
    int             _focusIndex;
    @private
    NSArray         *_items;
}

@property (nonatomic, strong) id clickdelegate;
@property (nonatomic, assign) int focusIndex;

- (id)initWithItems:(NSArray*)items viewFrame:(CGRect)viewFrame ctrStyle:(UISegmentedControlStyle)style focusIndex:(int)index;

- (void)setAccessibilityLabel:(int)index localizedString:(NSString*)localizedString;

- (void)segmentTouchDown:(id)sender;

- (void)segmentTouchCancel:(id)sender;

- (void)segmentTouchUp:(id)sender;
@end
