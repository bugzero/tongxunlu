//
//  NSObject+EZ.h
//  Tongxunlu
//
//  Created by 吴英杰 on 13-6-23.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface NSObject (EZ)

@property(nonatomic,strong)MBProgressHUD*   noticeView;

// Notice
- (void)showNotice:(NSString *)notice;
- (void)showNotice:(NSString *)notice duration:(NSTimeInterval)duration;
- (void)showNotice:(NSString *)notice image:(UIImage *)image;

@end
