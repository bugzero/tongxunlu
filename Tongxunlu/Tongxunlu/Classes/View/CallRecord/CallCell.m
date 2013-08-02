//
//  CallCell.m
//  Tongxunlu
//
//  Created by kongkong on 13-8-1.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "CallCell.h"
#import "NSDate+EZ.h"

@interface CallCell(){
    UILabel*        _label;
    UILabel*        _detail;
    UILabel*        _time;
    UIImageView*    _avatar;
    UIButton*       _call;
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
        UIView* hSep = [[UIView alloc]initWithFrame:CGRectMake(FULL_WIDTH-45, 4, 1,32)];
        hSep.backgroundColor = RGB(211, 211, 211);
        [self.contentView addSubview:hSep];
        
        _call = [UIButton buttonWithImage:[UIImage imageNamed:@"call"] backgroundImage:nil highlightedBackgroundImage:nil target:self action:@selector(takeCall)];
        _call.frame = CGRectMake(FULL_WIDTH-40, 2, 32, 32);
        [self.contentView addSubview:_call];
        
        /// separator
        UIView* separator = [[UIView alloc]initWithFrame:CGRectMake(0, 38, FULL_WIDTH, 2)];
        separator.backgroundColor = RGB(250, 250, 250);
        
        UIView* sep = [[UIView alloc]initWithFrame:separator.bounds];
        sep.backgroundColor = RGB(211, 211, 211);
        sep.height = 1;
        [separator addSubview:sep];
        
        [self.contentView addSubview:separator];
    }
    return self;
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
