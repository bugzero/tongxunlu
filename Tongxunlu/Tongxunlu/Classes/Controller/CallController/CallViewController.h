//
//  CallViewController.h
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CallViewShow = 1<<0,
    CallViewHide = 1<<1
}CallViewState;

@protocol CallViewStateDelegate;

@interface CallViewController : EZRootViewController

@property(nonatomic,assign)id<CallViewStateDelegate>delegate;
@property(nonatomic,assign)CallViewState callViewState;

-(void)showKeyBoard;
-(void)hideKeyBoard;
@end

@protocol CallViewStateDelegate <NSObject>

-(void)callViewControllerWillHideKeyBoard;
@end
