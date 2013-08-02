//
//  TXLKeyBoard.m
//  Tongxunlu
//
//  Created by kongkong on 13-6-12.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "TXLKeyBoard.h"
#import "UIButton+EZ.h"
#import <AudioToolbox/AudioToolbox.h>

@interface TXLKeyBoard(){
    SystemSoundID shortSound;
}

@end

@implementation TXLKeyBoard

-(id)initWithPosition:(CGPoint)position{
    self = [super initWithFrame:CGRectMake(position.x, position.y, FULL_WIDTH, 250)];
    if (self) {
        [self loadSound];
        [self loadBg];
        [self loadEdit];
        [self loadKeys];
    }
    
    return self;
}

-(void)loadSound{
    NSString* basePath = [EZinstance instanceWithKey:THEME_IMAGE_BASEPATH];
    
    NSString* path = [NSString stringWithFormat:@"%@/sounds/dial_0.wav",basePath];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        NSURL *soundURL = [NSURL fileURLWithPath:path];
        
        // Register sound file located at that URL as a system sound
        OSStatus err = AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL,
                                                        &shortSound);
        if (err != kAudioServicesNoError)
            NSLog(@"Could not load %@, error code: %ld", soundURL, err);
    }
}

-(void)loadBg{
    UIImageView* bg = [[UIImageView alloc]initWithFrame:self.bounds];
    bg.image = [[UIImage themeImageNamed:@"KeyboardBgNormal.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:20];
    bg.tag = -1;
    
    [self addSubview:bg];
}

-(void)loadEdit{
    /// 背景
    UIImageView* editView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, FULL_WIDTH, 50)];
    editView.image = [[UIImage themeImageNamed:@"DialTextBarBg"]stretchableImageWithLeftCapWidth:2 topCapHeight:4];
    editView.userInteractionEnabled = YES;
    
    [self addSubview:editView];
    
    /// 删除按钮
    UIButton* key = [UIButton buttonWithImage:nil backgroundImage:[UIImage themeImageNamed:@"KeyboardDeleteNormal"] highlightedBackgroundImage:[UIImage themeImageNamed:@"KeyboardDeletePress"] target:self action:@selector(keyPressAction:)];
    key.frame = CGRectMake(FULL_WIDTH-40-10, 5, 40, 40);
    key.tag = -100;
    [editView addSubview:key];
    
    /// 输入框
    UIImageView* editBg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 6, 240, 38)];
    
    editBg.image = [[UIImage themeImageNamed:@"DialCallTextNumberBgImage"]stretchableImageWithLeftCapWidth:6 topCapHeight:6];
    
    [editView addSubview:editBg];
    
    
    ///输入框 textfield
    _editPanel = [[UITextField alloc]initWithFrame:editBg.frame];
    _editPanel.left += 3;
    _editPanel.width -= 5;
    _editPanel.delegate = self;
    _editPanel.placeholder = @"请输入号码或者拼音搜索";
    _editPanel.text = @"";
    _editPanel.font = BOLD_FONT(22);
    _editPanel.textColor = RGB(255, 255, 255);
    [editBg addSubview:_editPanel];
}

-(void)loadKeys{
    CGFloat xOfffset = 0.0f ,yOffset = 50.0f;
    
    UIImage* bg = [[UIImage themeImageNamed:@"KeyboardBgNormal.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:20];
    
    UIImage* focus = [[UIImage themeImageNamed:@"KeyboardBgPress.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:20];
    
    for (short index = 0; index < 9; index ++) {
        
        NSString* keyImage = [NSString stringWithFormat:@"DialNumber%d.png",49+index];
        
        UIButton* key = [UIButton buttonWithImage:[UIImage themeImageNamed:keyImage] backgroundImage:bg highlightedBackgroundImage:focus target:self action:@selector(keyPressAction:)];
        
        key.frame = CGRectMake(xOfffset, yOffset, 106+((index+1)%3?0:1), 50);
        
        if (0 != index && 0 == (index+1)%3) {
            xOfffset = 0;
            yOffset += 50;
        }
        else{
            xOfffset += 106;
        }
        [self addSubview:key];
        
        key.tag = -(49+index);
    }
    
    UIButton* star = [UIButton buttonWithImage:[UIImage themeImageNamed:@"DialNumber42_53.png"] backgroundImage:bg highlightedBackgroundImage:focus target:self action:@selector(keyPressAction:)];
    star.frame = CGRectMake(xOfffset , yOffset, 106, 50);
    [self addSubview:star];
    star.tag = -(42+53);
    
    xOfffset += 106;
    
    UIButton* zero = [UIButton buttonWithImage:[UIImage themeImageNamed:@"DialNumber48.png"] backgroundImage:bg highlightedBackgroundImage:focus target:self action:@selector(keyPressAction:)];
    zero.frame = CGRectMake(xOfffset , yOffset, 106, 50);
    [self addSubview:zero];
    zero.tag = -48;
    xOfffset += 106;
    
    UIButton* message = [UIButton buttonWithImage:[UIImage themeImageNamed:@"DialNumber35_53.png"] backgroundImage:bg highlightedBackgroundImage:focus target:self action:@selector(keyPressAction:)];
    message.frame = CGRectMake(xOfffset , yOffset, 107, 50);
    [self addSubview:message];
    message.tag = -(35+53);
}

-(void)keyPressAction:(UIButton*)key{
    
    /// 删除
    if (key.tag == -100) {
        if (isEmptyStr(_editPanel.text)) {
            _editPanel.text = @"";
        }
        else{
            _editPanel.text = [_editPanel.text substringToIndex:[_editPanel.text length]-1];
        }
    }
    // 短信
    else if(key.tag == -88){
        [EZinstance sendMessage:_editPanel.text];
    }
    // 联系人
    else if (key.tag == -95){
        if (isEmptyStr(_editPanel.text)) {
            [self showNotice:@"没有输入号码"];
        }
        else{
            
            ABNewPersonViewController *newPersonViewController = [[ABNewPersonViewController alloc] init];

            ABRecordRef newPerson = ABPersonCreate();
            ABMutableMultiValueRef multiValue = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
            
            CFErrorRef error = NULL;
            multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            ABMultiValueAddValueAndLabel(multiValue, (__bridge CFTypeRef)(_editPanel.text), kABPersonPhoneMainLabel, NULL);
            ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiValue , &error);
            
            NSAssert(!error, @"Something bad happened here.");
            
            newPersonViewController.displayedPerson = newPerson;
            // Set delegate
            newPersonViewController.newPersonViewDelegate = self;
            UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:newPersonViewController];
            [[EZinstance instanceWithKey:K_NAVIGATIONCTL] presentModalViewController:navigation animated:YES];
        }
    }
    else{
        AudioServicesPlaySystemSound(shortSound);
        _editPanel.text = [NSString stringWithFormat:@"%@%d",_editPanel.text,-(key.tag+48)];
    }
}

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
	[[EZinstance instanceWithKey:K_NAVIGATIONCTL]  dismissModalViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFACTION_KEYBOARD_ADDPERSON_COMPLATE object:nil];
}

#pragma -mark uitexstfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

- (NSString*)number{
    return _editPanel.text;
}
@end
