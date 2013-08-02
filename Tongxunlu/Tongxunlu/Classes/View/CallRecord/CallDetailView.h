//
//  CallDetailView.h
//  Tongxunlu
//
//  Created by kongkong on 13-8-2.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallDetailView : UIControl<UITableViewDataSource,UITableViewDelegate>

-(id)initWithData:(NSArray*)dataList;

-(void)show;

@end
