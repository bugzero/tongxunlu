//
//  CallCell.m
//  Tongxunlu
//
//  Created by kongkong on 13-8-1.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "CallCell.h"
#import "NSDate+EZ.h"

@interface CallCell(){
    UILabel*        _label;
    UILabel*        _detail;
}

@end

@implementation CallCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, 120, 15)];
        _label.textAlignment = UITextAlignmentLeft;
        _label.textColor =[UIColor blackColor];
        _label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label];
        
        _detail = [[UILabel alloc]initWithFrame:CGRectMake(135, 2, 185, 20)];
        _detail.textAlignment = UITextAlignmentLeft;
        [self.contentView addSubview:_detail];
        
    }
    return self;
    
}

-(void)reloadDataWithEntity:(AccountEntity*)entity{

    
    if (entity.type == RECORD_DETAIL) {
        
        NSString* time = [NSDate humanDateFromTimestamp:entity.time];
//        self.textLabel.text =[NSString stringWithFormat:@"\t\t%@\t\t%@%@", entity.name,entity.phone,time];
        
        _label.text = [NSString stringWithFormat:@"\t\t%@", entity.name];
        _detail.text = [NSString stringWithFormat:@"%@\t\t%@",entity.phone,time];
        
        _label.font = FONT(13);
        _detail.font = FONT(12);
    }
    else{
        _label.text = [NSString stringWithFormat:@"%@(%d)",entity.name,entity.count];
        _detail.text = entity.phone;
        
        _label.font = FONT(15);
        _detail.font = FONT(12);
    }
    
    self.type = entity.type;
}
@end
