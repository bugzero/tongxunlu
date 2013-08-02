//
//  CallCell.m
//  Tongxunlu
//
//  Created by kongkong on 13-8-1.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "CallCell.h"
#import "NSDate+EZ.h"
#import <QuartzCore/QuartzCore.h>

@interface CallCell(){
    UILabel*        _label;
    UILabel*        _detail;
    UILabel*        _time;
    UIImageView*    _avatar;
    UIView*         _callPanel;
}

@end

@implementation CallCell

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
        
        /// avatar
        _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(10, 2, 36, 36)];
        _avatar.image = [UIImage imageNamed:@"default_contract"];
        [self.contentView addSubview:_avatar];
        
        /// label
        _label = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 120, 15)];
        _label.textAlignment = UITextAlignmentLeft;
        _label.textColor =[UIColor blackColor];
        _label.backgroundColor = [UIColor clearColor];
        _label.font = BOLD_FONT(16);
        [self.contentView addSubview:_label];
        
        //// detail
        _detail = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, 120, 20)];
        _detail.textAlignment = UITextAlignmentLeft;
        _detail.textColor = RGB(94, 94, 94);
        _detail.backgroundColor = [UIColor clearColor];
        _detail.font = FONT(13);
        [self.contentView addSubview:_detail];
        
        ///call
        _callPanel = [[UIView alloc]initWithFrame:CGRectMake(FULL_WIDTH-45, 0, 45, 40)];
        [self.contentView addSubview:_callPanel];
        
        UIView* hSep = [[UIView alloc]initWithFrame:CGRectMake(0, 4, 1,32)];
        hSep.backgroundColor = RGB(211, 211, 211);
        [_callPanel addSubview:hSep];
        
        UIButton* call= [UIButton buttonWithImage:[UIImage imageNamed:@"call"] backgroundImage:nil highlightedBackgroundImage:nil target:self action:@selector(takeCall)];
        call.frame = CGRectMake(5, 2, 32, 32);
        [_callPanel addSubview:call];
        
        
        /// separator
        UIView* separator = [[UIView alloc]initWithFrame:CGRectMake(0, 38, FULL_WIDTH, 2)];
        separator.backgroundColor = RGB(250, 250, 250);
        
        UIView* sep = [[UIView alloc]initWithFrame:separator.bounds];
        sep.backgroundColor = RGB(211, 211, 211);
        sep.height = 1;
        [separator addSubview:sep];
        
        [self.contentView addSubview:separator];
        
        // swip to remove
        UISwipeGestureRecognizer* ges = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeState)];
        ges.direction = UISwipeGestureRecognizerDirectionLeft;
        
        [self addGestureRecognizer:ges];
    }
    return self;
}

-(void)changeState{
#ifdef SHOW_PRE_RELEASE
    
    if ([self viewWithTag:-1001]) {
        [UIView animateWithDuration:EZ_ANIMATION_DURATION animations:^{
            _callPanel.left = FULL_WIDTH-45;
            [self viewWithTag:-1002].left = FULL_WIDTH;
        } completion:^(BOOL finished) {
            [[self viewWithTag:-1001]removeFromSuperview];
            [[self viewWithTag:-1002]removeFromSuperview];
        }];
    }
    else{
        UIControl* mask = [[UIControl alloc]initWithFrame:self.bounds];
        [mask addTarget:self action:@selector(changeState) forControlEvents:UIControlEventTouchDown];
        mask.backgroundColor = [UIColor clearColor];
        mask.tag = -1001;
        [self addSubview:mask];
        
        UIButton* del = [[UIButton alloc]initWithFrame:CGRectMake(FULL_WIDTH, 6, 65, 26)];
        del.tag = -1002;
        del.titleLabel.font = BOLD_FONT(12);
        del.layer.masksToBounds = YES;
        del.layer.cornerRadius = 2;
        del.backgroundColor = [UIColor colorWithRed:0.6 green:0 blue:0 alpha:1];
        [del shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, -3) shadowRadius:2 shadowOpacity:0.6];
        [del setTitle:@"删除记录" forState:UIControlStateNormal];
        [mask addSubview:del];
        
        [del addTarget:self action:@selector(delcell) forControlEvents:UIControlEventTouchUpInside];
        
        [UIView animateWithDuration:EZ_ANIMATION_DURATION animations:^{
            _callPanel.left = FULL_WIDTH-110;
            del.left = FULL_WIDTH-70;
        }];
    }
    
#endif
}

-(void)delcell{
    if ([_delegate respondsToSelector:@selector(delcell:)]) {
        [_delegate performSelector:@selector(delcell:) withObject:self];
    }
}

-(void)reloadDataWithEntity:(AccountEntity*)entity bEnd:(BOOL)bEnd{
    
    if (isEmptyStr(entity.name)) {
        _label.text = [NSString stringWithFormat:@"%@(%d)",entity.phone,entity.count];
    }
    else{
        _label.text = [NSString stringWithFormat:@"%@(%d)",entity.name,entity.count];
    }
    
    _detail.text = entity.phone;
    
    _time.text = [NSDate humanDateFromTimestamp:entity.time];
    
    self.type = entity.type;
    
    self.entity = entity;
}

-(void)takeCall{
    [EZinstance makeCall:_entity.phone];
}
@end
