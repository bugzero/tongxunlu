//
//  DropDownTitleView.h
//  Tongxunlu
//
//  Created by 吴英杰 on 13-7-7.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownTitleView : UIButton{
    
    UILabel*        _label;
    UIImageView*    _arrow;
    
}
-(id)initWithFrame:(CGRect)frame title:(NSString*)title action:(id)action selector:(SEL)selector;

@property(nonatomic,assign)BOOL drapFlag;

-(void)setLabel:(NSString*)label;
@end