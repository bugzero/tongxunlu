//
//  UIImage+EZ.h
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

#define THEME_IMAGE_BASEPATH    @"imageThemeBasePath"

@interface UIImage (EZ)

+(UIImage*)themeImageNamed:(NSString*)imageName;

@end
