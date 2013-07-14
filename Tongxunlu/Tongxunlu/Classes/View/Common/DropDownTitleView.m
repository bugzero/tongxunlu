//
//  DropDownTitleView.m
//  Tongxunlu
//
//  Created by 吴英杰 on 13-7-7.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "DropDownTitleView.h"


@implementation DropDownTitleView

-(id)initWithFrame:(CGRect)frame title:(NSString *)title action:(id)action selector:(SEL)selector{
    if ((self = [super initWithFrame:frame])) {
        
        [self loadTitle];
        
        _label.text = title;

        [self loadArrow];
        
        _drapFlag = NO;
        
        [self addTarget:action action:selector forControlEvents:UIControlEventTouchUpInside];
        
//        self setBackgroundImage:<#(UIImage *)#> forState:<#(UIControlState)#>
    }
    return self;
}

-(void)loadArrow{
    CGFloat width = [_label.text sizeWithFont:_label.font].width;
    
    _arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NavDropDownArrowDown"]];
    
    _arrow.left = width+10;
    _arrow.centerY = self.height/2;
    
    [self addSubview:_arrow];
}

-(void)loadTitle{
    _label = [[UILabel alloc]initWithFrame:self.bounds];
    _label.width -= 20;
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor whiteColor];
    _label.font = BOLD_FONT(18);

    _label.textAlignment = UITextAlignmentCenter;
    
    [self addSubview:_label];
}

-(void)setDrapFlag:(BOOL)drapFlag{
    _drapFlag = drapFlag;
    
    /// 切换图片
    if (!_drapFlag)
        _arrow.image = [UIImage imageNamed:@"NavDropDownArrowDown"];
    else
        _arrow.image = [UIImage imageNamed:@"NavDropDownArrowUp"];
}

-(void)setLabel:(NSString *)label{
    _label.text = label;
    //
    //    _arrow.contentMode = UIViewContentModeScaleAspectFill;
}

@end
