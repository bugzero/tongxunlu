//
//  RootViewController.m
//  cellMaxMinDemo
//
//  Created by Sagar Kothari on 19/07/11.
//  Copyright 2011 SagarRKothari-iPhone. All rights reserved.
//

#import "DeptChoiceViewController.h"
#import "DeptObject.h"

@implementation DeptChoiceViewController
@synthesize delegate = _delegate;
@synthesize arrayOriginal;
@synthesize arForTable;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"State.data"];
    
	NSDictionary *dTmp = [NSKeyedUnarchiver unarchiveObjectWithFile: filePath];
    
    
	self.arrayOriginal=[dTmp valueForKey:@"Objects"];
	
	self.arForTable=[[NSMutableArray alloc] init];
	[self.arForTable addObjectsFromArray:self.arrayOriginal];
	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.arForTable count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
	cell.textLabel.text=[[self.arForTable objectAtIndex:indexPath.row] valueForKey:@"name"];
	[cell setIndentationLevel:[[[self.arForTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue]];
	
    return cell;
}

- (void)setChoiceDepartId:(DeptObject*)dtObj
{
    [[NSUserDefaults standardUserDefaults]setObject:dtObj.deptId forKey:@"searchDeptId"];
    if (_delegate && [_delegate respondsToSelector:@selector(closePopView)]) {
        [_delegate closePopView];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.row);
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	DeptObject *dtObj = [self.arForTable objectAtIndex:indexPath.row];
	if([dtObj.depts count] > 0) {
		NSArray *ar = dtObj.depts;
		
		BOOL isAlreadyInserted=NO;
		
		for(DeptObject *dInner in ar ){
			NSInteger index=[self.arForTable indexOfObjectIdenticalTo:dInner];
			isAlreadyInserted=(index>0 && index!=NSIntegerMax);
			if(isAlreadyInserted)
            {
               NSLog(@"%@",[arForTable objectAtIndex:indexPath.row]);
              [self setChoiceDepartId:dtObj];
               break;
            }
		}
		
		if(isAlreadyInserted) {
			[self miniMizeThisRows:ar];
		} else {		
			NSUInteger count=indexPath.row+1;
			NSMutableArray *arCells=[NSMutableArray array];
			for(NSDictionary *dInner in ar ) {
				[arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
				[self.arForTable insertObject:dInner atIndex:count++];
			}
			[tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
		}
	}else{
        //选中最底下的
        [self setChoiceDepartId:dtObj];
    }
}

-(void)miniMizeThisRows:(NSArray*)ar{
	
	for(DeptObject *dInner in ar ) {
		NSUInteger indexToRemove=[self.arForTable indexOfObjectIdenticalTo:dInner];
		NSArray *arInner = dInner.depts;
		if(arInner && [arInner count]>0){
			[self miniMizeThisRows:arInner];
		}
		
		if([self.arForTable indexOfObjectIdenticalTo:dInner]!=NSNotFound) {
			[self.arForTable removeObjectIdenticalTo:dInner];
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
												[NSIndexPath indexPathForRow:indexToRemove inSection:0]
												]
							  withRowAnimation:UITableViewRowAnimationRight];
		}
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setArForTable:nil];
    [self setArrayOriginal:nil];
}

@end
