//
//  ViewController.m
//  CollapseClick
//
//  Created by Ben Gordon on 2/28/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import "SiteViewCtl.h"
#import "LoginViewController.h"
#import "User.h"

@interface SiteViewCtl ()
@end

@implementation SiteViewCtl

- (void)viewDidLoad
{
    [super viewDidLoad];
    myCollapseClick.CollapseClickDelegate = self;
    [myCollapseClick reloadCollapseClick];
    
    // If you want a cell open on load, run this method:
    [myCollapseClick openCollapseClickCellAtIndex:1 animated:NO];
    /*
     // If you'd like multiple cells open on load, create an NSArray of NSNumbers
     // with each NSNumber corresponding to the index you'd like to open.
     // - This will open Cells at indexes 0,2 automatically
     
     NSArray *indexArray = @[[NSNumber numberWithInt:0],[NSNumber numberWithInt:2]];
     [myCollapseClick openCollapseClickCellsWithIndexes:indexArray animated:NO];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Collapse Click Delegate

// Required Methods
-(int)numberOfCellsForCollapseClick {
    return 6;
}

-(NSString *)titleForCollapseClickAtIndex:(int)index {
    switch (index) {
        case 0:
            if ([[User instance]isLogin]) {
                return @"退出";
            }
            return @"登陆";
            break;
        case 1:
            return @"修改密码";
            break;
        case 2:
            return @"同步通讯录";
            break;
        case 3:
            return @"如何使用";
            break;
        case 4:
            return @"检查更新";
            break;
        case 5:
            return @"关于我们";
            break;
            
        default:
            return @"";
            break;
    }
}

-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
    switch (index) {
        case 0:
//            if (![[User instance]isLogin]) {
//                LoginViewController  *_loginView = [[LoginViewController alloc]init];
//                [_loginView setTitle:nil];
//                User* user = [User instance];
//                if (!user.loginVC) {
//                    user.loginVC = _loginView;
//                }
//
//                return _loginView.view;
//            }else{
////                [User logout];
//                return [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
//            }
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
            break;
        case 1:
            return modifyPwdView;
            break;
        case 2:
            return syncView;
            break;
        case 3:
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
            break;
        case 4:
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
            break;
        case 5:
            return aboutView;
            break;
            
        default:
            return aboutView;
            break;
    }
}


// Optional Methods

-(UIColor *)colorForCollapseClickTitleViewAtIndex:(int)index {
//    return [UIColor colorWithRed:223/255.0f green:47/255.0f blue:51/255.0f alpha:1.0];
    return RGB(94, 94, 94);
}


-(UIColor *)colorForTitleLabelAtIndex:(int)index {
    return [UIColor colorWithWhite:1.0 alpha:0.85];
}

-(UIColor *)colorForTitleArrowAtIndex:(int)index {
    return [UIColor colorWithWhite:0.0 alpha:0.25];
}

-(void)didClickCollapseClickCellAtIndex:(int)index isNowOpen:(BOOL)open {
    NSLog(@"%d and it's open:%@", index, (open ? @"YES" : @"NO"));
    if (index==0) {
        if ([[User instance]isLogin]) {
            [User logout];
        }else{
            [User loginWithBlock:^{
            }];
        }
        [myCollapseClick reloadCollapseClick];
    }
}


#pragma mark - TextField Delegate for Demo
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}



@end
