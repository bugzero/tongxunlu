//
//  ViewController.h
//  CollapseClick
//
//  Created by Ben Gordon on 2/28/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollapseClick.h"
#import "TXLSyncView.h"

@interface SiteViewCtl : EZRootViewController <CollapseClickDelegate,UITextFieldDelegate> {
    IBOutlet UIView *modifyPwdView;
    IBOutlet UIView *aboutView;;
//    IBOutlet UIView *test3View;
    IBOutlet TXLSyncView *syncView;
    
    __weak IBOutlet CollapseClick *myCollapseClick;
}


@end
