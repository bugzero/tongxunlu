//
//  ShareCell.m
//  Tongxunlu
//
//  Created by 吴英杰 on 13-7-14.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "ShareCell.h"

@implementation ShareCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.allianceNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,2,200,33)];
        //        self.nameLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.allianceNameLabel];
        
        self.userNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(255 ,2 ,50 ,33)];
        [self.contentView addSubview:self.userNumLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSDictionary *)rs
{
    self.allianceNameLabel.text = [rs objectForKey:@"sbName"];
    self.userNumLabel.text  = [NSString stringWithFormat:@"(%d)",[[rs objectForKey:@"userCount"] intValue]];
    self.sbId = [[rs objectForKey:@"sbId"] intValue];
}
@end
