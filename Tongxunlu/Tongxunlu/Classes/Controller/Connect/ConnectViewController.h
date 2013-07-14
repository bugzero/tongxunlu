//
//  ConnectViewController.h
//  Tongxunlu
//
//  Created by kongkong on 13-6-13.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "EZRootViewController.h"
#import "MXDropDownList.h"
#import "ContractViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ConnectViewController : EZRootViewController<ABPersonClickDelegate,ABNewPersonViewControllerDelegate,MXDropDownListDelegate>
{
    
}
@property (strong, nonatomic) MXDropDownList *dropDownList;
@property (strong, nonatomic) UIImageView    *dropDownArrowImageView;
@end