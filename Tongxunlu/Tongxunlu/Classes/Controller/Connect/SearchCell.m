//
//  SearchCell.m
//  Sensibleness
//
//  Created by 吴英杰 on 13-6-27.
//
//

#import "SearchCell.h"

@implementation SearchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,2,200,26)];
//        self.nameLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.nameLabel];
        
        self.userPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(5 ,26 ,141 ,21)];
        [self.contentView addSubview:self.userPhoneLabel];
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
    if ([rs containKey:@"compId"] && [rs objectForKey:@"compId"]!=nil) {
        self.compId = [[rs objectForKey:@"compId"] intValue];
    }
    
    if ([rs containKey:@"compTel"] && nil !=([rs objectForKey:@"compTel"])) {
        self.compTel = [rs objectForKey:@"compTel"];
    }
    
    if ([rs containKey:@"depId"] && nil !=([rs objectForKey:@"depId"])) {
        self.depId = [[rs objectForKey:@"depId"] intValue];
    }
    
    if ([rs containKey:@"email"] && nil !=([rs objectForKey:@"email"])) {
        self.email = [rs objectForKey:@"email"];
    }
    
    if ([rs containKey:@"homeTel"] && nil !=([rs objectForKey:@"homeTel"])) {
        self.homeTel = [rs objectForKey:@"homeTel"];
    }
    
    if ([rs containKey:@"msn"] && nil !=([rs objectForKey:@"msn"])) {
        self.msn = [rs objectForKey:@"msn"];
    }
    
    if ([rs containKey:@"name"] && nil !=([rs objectForKey:@"name"])) {
        self.name = [rs objectForKey:@"name"];
        self.nameLabel.text = self.name;
    }
    
    if ([rs containKey:@"position"] && nil !=([rs objectForKey:@"position"])) {
        self.position = [rs objectForKey:@"position"];
    }
    
    if ([rs containKey:@"qq"] && nil !=([rs objectForKey:@"qq"])) {
        self.qq = [rs objectForKey:@"qq"];
    }
    
    if ([rs containKey:@"userId"] && nil !=([rs objectForKey:@"userId"])) {
        self.userId = [[rs objectForKey:@"userId"] intValue];
    }
    
    if ([rs containKey:@"userPhone"] && nil !=([rs objectForKey:@"userPhone"])) {
        self.userPhone = [[rs objectForKey:@"userPhone"] intValue];
        self.userPhoneLabel.text = [rs objectForKey:@"userPhone"];
    }
    
    if ([rs containKey:@"virtualTel"] && nil !=([rs objectForKey:@"virtualTel"])) {
        self.virtualTel = [[rs objectForKey:@"virtualTel"] intValue];
    }
    
}
@end
