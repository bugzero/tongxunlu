//
//  PersonViewController.h
//  Tongxunlu
//
//  Created by kongkong on 13-7-14.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "EZRootViewController.h"
#import <AddressBookUI/AddressBookUI.h>

@interface PersonViewController : EZRootViewController

-(id)initWithPerson:(ABRecordRef)person;

@end
