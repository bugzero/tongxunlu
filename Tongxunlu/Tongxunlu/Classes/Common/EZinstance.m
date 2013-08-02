//
//  EZinstance.m
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "EZinstance.h"
#import <objc/runtime.h>
#import "DBManager.h"

@interface EZinstance()
@property(nonatomic,retain)NSMutableDictionary* instanceDic;
@end

@implementation EZinstance

#pragma -mark
#pragma -mark 单例对象
+(EZinstance*)instance{
    static EZinstance *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[EZinstance alloc] init];
        
        _instance.instanceDic = [[NSMutableDictionary alloc]initWithCapacity:1];
        
    });
    return _instance;
}

#pragma -mark
#pragma -mark public method
+(id)instanceWithKey:(NSString *)key{
    EZinstance* instance = [EZinstance instance];
    
    if ([instance.instanceDic containKey:key]) {
        return [instance.instanceDic objectForKey:key];
    }
    
    return nil;
}

+(void)setInstance:(id)instanceValue key:(NSString*)key{
    
    if (!instanceValue || !key || [key.trim isEqualToString:@""]) {
        return;
    }
    
    EZinstance* instance = [EZinstance instance];
    
    [instance.instanceDic setSafeObject: instanceValue forKey:key];
}

+ (void)makeCall:(NSString *)number
{
    NSString* name = [DictStoreSupport readPoConfigWithKey:number];
    NSString* sql = [NSString stringWithFormat:@"INSERT INTO `callrecord`(phone,name,time) VALUES('%@','%@','%.0lf');",number,isEmptyStr(name)?@"":name,[[NSDate date]timeIntervalSince1970]];
    
    DBManager* db = [EZinstance instanceWithKey:K_DBMANAGER];
    [db insertSql:sql];
    
    NSURL* telUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",number]];
    [[UIApplication sharedApplication] openURL:telUrl];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFACTION_TAKE_CALL object:nil];
}

+ (void)sendMessage:(NSString *)phone{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            [[EZinstance instance] displaySMSComposerSheet:phone];
        }
        else {
            [[EZinstance instance] showNotice:@"设备没有短信功能" duration:2.0];
            
        }
    }
    else {
        [self showNotice:@"iOS版本过低,iOS4.0以上才支持程序内发送短信" duration:2.0];
    }
}

-(void)displaySMSComposerSheet:(NSString*)phone
{
    
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    
    if (!isEmptyStr(phone)) {
        
        picker.recipients = [NSArray arrayWithObjects:phone, nil];
    }
    
    [[EZinstance instanceWithKey:K_NAVIGATIONCTL] presentViewController:picker animated:YES completion:nil];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            // LOG_EXPR(@"Result: SMS sending canceled");
            [self showNotice:@"短信发送取消" duration:1.0];
            break;
        case MessageComposeResultSent:
            // LOG_EXPR(@"Result: SMS sent");
            [self showNotice:@"短信已发送成功" duration:1.0];
            break;
        case MessageComposeResultFailed:
            //[UIAlertView quickAlertWithTitle:@"短信发送失败" messageTitle:nil dismissTitle:@"关闭"];
            [self showNotice:@"短信发送失败" duration:1.0];
            break;
        default:
            // LOG_EXPR(@"Result: SMS not sent");
            [self showNotice:@"SMS not sent" duration:1.0];
            break;
    }
    [[EZinstance instanceWithKey:K_NAVIGATIONCTL] dismissModalViewControllerAnimated:YES];
}


@end
