//
//  SearchCell.h
//  Sensibleness
//
//  Created by 吴英杰 on 13-6-27.
//
//

#import <UIKit/UIKit.h>
@interface SearchCell : UITableViewCell

@property (assign,nonatomic) int compId;

@property (strong , nonatomic) NSString  *compTel;

@property (assign, nonatomic) int  depId;

@property (strong, nonatomic) NSString  *email;

@property (strong, nonatomic) NSString  *homeTel;

@property (strong, nonatomic) NSString  *msn;

@property (strong, nonatomic) NSString  *name;

@property (strong, nonatomic) NSString  *position;

@property (strong, nonatomic) NSString  *qq;

@property (assign,  nonatomic) int userId;

@property (assign ,nonatomic) int userPhone;

@property (assign,nonatomic) int virtualTel;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *userPhoneLabel;

-(void)setData:(NSDictionary *)rs;

@end
