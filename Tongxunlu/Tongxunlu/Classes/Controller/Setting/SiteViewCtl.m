//
//  ViewController.m
//  CollapseClick
//
//  Created by Ben Gordon on 2/28/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import "SiteViewCtl.h"

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
    return 4;
}

-(NSString *)titleForCollapseClickAtIndex:(int)index {
    switch (index) {
        case 0:
            return @"注释帐号";
            break;
        case 1:
            return @"登陆";
            break;
        case 2:
            return @"同步通讯录";
            break;
        case 3:
            return @"清除缓存数据";
            break;
            
        default:
            return @"";
            break;
    }
}

-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
    switch (index) {
        case 0:
            return test1View;
            break;
        case 1:
            return test2View;
            break;
        case 2:
            return test3View;
            break;
        case 3:
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
            break;
            
        default:
            return test1View;
            break;
    }
}


// Optional Methods

-(UIColor *)colorForCollapseClickTitleViewAtIndex:(int)index {
    return [UIColor colorWithRed:223/255.0f green:47/255.0f blue:51/255.0f alpha:1.0];
}


-(UIColor *)colorForTitleLabelAtIndex:(int)index {
    return [UIColor colorWithWhite:1.0 alpha:0.85];
}

-(UIColor *)colorForTitleArrowAtIndex:(int)index {
    return [UIColor colorWithWhite:0.0 alpha:0.25];
}

-(void)didClickCollapseClickCellAtIndex:(int)index isNowOpen:(BOOL)open {
    NSLog(@"%d and it's open:%@", index, (open ? @"YES" : @"NO"));
}


#pragma mark - TextField Delegate for Demo
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}



@end
