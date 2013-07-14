//
//  PersonViewController.m
//  Tongxunlu
//
//  Created by kongkong on 13-7-14.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "PersonViewController.h"

@interface PersonViewController (){
}

@property(nonatomic,assign)ABRecordRef person;
@end

@implementation PersonViewController

-(id)initWithPerson:(ABRecordRef)person{
    if ((self = [super init])) {
        self.person = person;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"联系人详情"];
    
    [self setLeftbarItem:[UIButton backButtonWithTarget:self action:@selector(back)]];
    
    ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
    
    picker.displayedPerson = self.person;
    
    picker.view.top = NAVBAR_HEIGHT;
    
    [self.view addSubview:picker.view];
}

@end
