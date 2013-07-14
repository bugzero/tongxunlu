//
//  UIImage+EZ.m
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "UIImage+EZ.h"

@implementation UIImage (EZ)

+(UIImage *)themeImageNamed:(NSString *)imageName{
    NSString* basePath = [EZinstance instanceWithKey:THEME_IMAGE_BASEPATH];

    NSString* path = [NSString stringWithFormat:@"%@/%@",basePath,imageName];
    if (![path hasSuffix:@".png"]) {
        path = [NSString stringWithFormat:@"%@.png",path];
    }
    
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    
    return image;
    
}

@end
