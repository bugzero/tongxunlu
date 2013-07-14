//
//  ShareCell.h
//  Tongxunlu
//
//  Created by 吴英杰 on 13-7-14.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareCell : UITableViewCell

@property (strong, nonatomic) UILabel *allianceNameLabel;

@property (strong, nonatomic) UILabel *userNumLabel;

@property (assign, nonatomic) int     sbId;

-(void)setData:(NSDictionary *)rs;

@end
