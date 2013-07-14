//
//  TXLKeyBoard.h
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXLKeyBoard : UIView<UITextFieldDelegate>{
    NSMutableArray*     _keyButtons;
    UITextField*        _editPanel;
}

-(id)initWithPosition:(CGPoint)position;

- (NSString*)number;
@end
