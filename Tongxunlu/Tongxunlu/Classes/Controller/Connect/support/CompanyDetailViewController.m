//
//  CompanyDetailViewController.m
//  Tongxunlu
//
//  Created by 吴英杰 on 13-7-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "CompanyDetailViewController.h"

@interface CompanyDetailViewController ()

@end

@implementation CompanyDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(137, 57, 154, 21)];
        [self.view addSubview:self.nameLabel];
        
        
        self.deptNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(137, 88, 154, 24)];
        [self.view addSubview:self.deptNameLabel];
        
        self.positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(137, 122, 154, 24)];
        [self.view addSubview:self.positionLabel];
        
        self.userPhoneLable = [[UILabel alloc]initWithFrame:CGRectMake(137, 156, 154, 24)];
        [self.view addSubview:self.userPhoneLable];
        
        self.virtualTelLabel = [[UILabel alloc]initWithFrame:CGRectMake(137, 188, 154, 24)];
        [self.view addSubview:self.virtualTelLabel];
        
        self.compTelLabel = [[UILabel alloc]initWithFrame:CGRectMake(137, 219, 154, 24)];
        [self.view addSubview:self.compTelLabel];
        
        self.homeTelLabel = [[UILabel alloc]initWithFrame:CGRectMake(137, 253, 154, 24)];
        [self.view addSubview:self.homeTelLabel];
        
        self.emailLable = [[UILabel alloc]initWithFrame:CGRectMake(137, 287, 169, 24)];
        [self.view addSubview:self.emailLable];
        
        self.msnLabel = [[UILabel alloc]initWithFrame:CGRectMake(137, 319, 205, 24)];
        [self.view addSubview:self.msnLabel];
        
        self.qqLabel = [[UILabel alloc]initWithFrame:CGRectMake(137, 351, 154, 24)];
        [self.view addSubview:self.qqLabel];
        
        self.sendMessageBtn = [UIButton buttonWithTitle:@"免费短信"
                                                  image:[[UIImage imageNamed:@"btn_bg"]stretchableImageWithLeftCapWidth:2 topCapHeight:1]
                                       highlightedImage:[[UIImage imageNamed:@"btn_selected"]stretchableImageWithLeftCapWidth:2 topCapHeight:1]
                                                 target:self
                                                 action:@selector(sendMessage:)];
        self.sendMessageBtn.titleLabel.font = FONT(22);
        [self.sendMessageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sendMessageBtn.frame = CGRectMake(40, self.qqLabel.bottom+10, 240, 46);
        
        [self.view addSubview:self.sendMessageBtn];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)displaySMSComposerSheet
{

    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    
    picker.recipients = [NSArray arrayWithObjects:self.userPhoneLable.text, nil];
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
//    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
//    picker.messageComposeDelegate = self;
//    
//    [self presentModalViewController:picker animated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    switch (result)
    {
        case MessageComposeResultCancelled:
           // LOG_EXPR(@"Result: SMS sending canceled");
            [self showNotice:@"短信发送取消" duration:2.0];
            break;
        case MessageComposeResultSent:
           // LOG_EXPR(@"Result: SMS sent");
            [self showNotice:@"短信已发送成功" duration:2.0];
            break;
        case MessageComposeResultFailed:
            //[UIAlertView quickAlertWithTitle:@"短信发送失败" messageTitle:nil dismissTitle:@"关闭"];
            [self showNotice:@"短信发送失败" duration:2.0];
            break;
        default:
           // LOG_EXPR(@"Result: SMS not sent");
            [self showNotice:@"SMS not sent" duration:2.0];
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)sendMessage:(id)sender {
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        }
        else {
            [self showNotice:@"设备没有短信功能" duration:2.0];

        }
    }
    else {
        [self showNotice:@"iOS版本过低,iOS4.0以上才支持程序内发送短信" duration:2.0];
    }
}

- (void)setShowDatas:(NSDictionary*)dict
{

    self.compTelLabel.text = [dict objectForKey:@"compTel"];

    self.deptNameLabel.text = [dict objectForKey:@"deptName"];

    self.emailLable.text = [dict objectForKey:@"email"];

    self.homeTelLabel.text = [dict objectForKey:@"homeTel"];

    self.msnLabel.text = [dict objectForKey:@"msn"];

    self.nameLabel.text = [dict objectForKey:@"name"];

    self.positionLabel.text = [dict objectForKey:@"position"];

    self.qqLabel.text = [dict objectForKey:@"qq"];
    
    self.userPhoneLable.text = [dict objectForKey:@"userPhone"];

//    self.userId = [dict objectForKey:@"userId"];

    self.virtualTelLabel.text = [dict objectForKey:@"virtualTel"];

}

- (void)viewDidUnload {
    [self setNameLabel:nil];
    [self setDeptNameLabel:nil];
    [self setPositionLabel:nil];
    [self setUserPhoneLable:nil];
    [self setCompTelLabel:nil];
    [self setEmailLable:nil];
    [self setMsnLabel:nil];
    [self setQqLabel:nil];
    [self setHomeTelLabel:nil];
    [super viewDidUnload];
}
@end
