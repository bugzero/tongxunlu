//
//  CompanyDetailViewController.h
//  Tongxunlu
//
//  Created by 吴英杰 on 13-7-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "EZRootViewController.h"
#import <MessageUI/MFMessageComposeViewController.h>

@interface CompanyDetailViewController : EZRootViewController<MFMessageComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *positionLabel;

@property (strong, nonatomic) IBOutlet UILabel *deptNameLabel;


@property (strong, nonatomic) IBOutlet UILabel  *emailLable;

@property (strong, nonatomic) IBOutlet UILabel  *homeTelLabel;

@property (strong, nonatomic) IBOutlet UILabel  *msnLabel;

@property (strong, nonatomic) IBOutlet UILabel *qqLabel;

//@property (assign,  nonatomic) IBOutlet UILabel *userIdLabel;

@property (strong ,nonatomic) IBOutlet UILabel *userPhoneLable;

@property (strong,nonatomic) IBOutlet UILabel *virtualTelLabel;
@property (strong, nonatomic) IBOutlet UILabel *compTelLabel;

@property(strong,nonatomic)IBOutlet UIButton* sendMessageBtn;
- (IBAction)sendMessage:(id)sender;
- (void)setShowDatas:(NSDictionary*)dict;
@end
