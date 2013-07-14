//
//  RootViewController.h
//  cellMaxMinDemo
//
//  Created by Sagar Kothari on 19/07/11.
//  Copyright 2011 SagarRKothari-iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CloseDelegate <NSObject>

- (void)closePopView;

@end

@interface DeptChoiceViewController : UITableViewController {
	id          _delegate;
}

@property (nonatomic, strong) NSArray *arrayOriginal;
@property (nonatomic, strong) NSMutableArray *arForTable;
@property (nonatomic, strong) id   delegate;

-(void)miniMizeThisRows:(NSArray*)ar;

@end
