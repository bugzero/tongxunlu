//
//  MasterViewController.m
//  datoucontacts
//
//  Created by houwenjie on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContractViewController.h"
#import "pinyin.h"
#import "POAPinyin.h"
#import <EventKit/EventKit.h>
#import "PersonViewController.h"

@implementation ContractViewController
@synthesize delegate = _delegate;

-(id)init{
    if ((self = [super init])) {
        filteredArray=[[NSMutableArray alloc] init];
        sectionDic= [[NSMutableDictionary alloc] init];
        phoneDic=[[NSMutableDictionary alloc] init];
        contactDic=[[NSMutableDictionary alloc] init];
    }
    return self;
}


// 导入通讯录
-(void)loadContacts
{
    [sectionDic removeAllObjects];
    [phoneDic   removeAllObjects];
    [contactDic removeAllObjects];
    for (int i = 0; i < 26; i++) [
                                  sectionDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'A'+i]];
    [sectionDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'#']];
    
    ABAddressBookRef myAddressBook =ABAddressBookCreate();
    
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(myAddressBook);
    CFMutableArrayRef mresults=CFArrayCreateMutableCopy(kCFAllocatorDefault,
                                                        CFArrayGetCount(results),
                                                        results);
    //将结果按照拼音排序，将结果放入mresults数组中
    CFArraySortValues(mresults,
                      CFRangeMake(0, CFArrayGetCount(results)),
                      (CFComparatorFunction) ABPersonComparePeopleByName,
                      (void*) ABPersonGetSortOrdering());
    //遍历所有联系人
    for (int k=0;k<CFArrayGetCount(mresults);k++) {
        ABRecordRef record=CFArrayGetValueAtIndex(mresults,k);
        NSString *personname = (__bridge NSString *)(ABRecordCopyCompositeName(record));
        ABMultiValueRef phone = ABRecordCopyValue(record, kABPersonPhoneProperty);
        ABRecordID recordID=ABRecordGetRecordID(record);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            NSRange range=NSMakeRange(0,3);
            NSString *str=[personPhone substringWithRange:range];
            if ([str isEqualToString:@"+86"]) {
                personPhone=[personPhone substringFromIndex:3];
            }
            [DictStoreSupport writeConfigWithKey:personPhone WithValue:personname];
            [phoneDic setObject:(__bridge id)(record) forKey:[NSString stringWithFormat:@"%@%d",personPhone,recordID]];
            
        }
        char first=pinyinFirstLetter([personname characterAtIndex:0]);
        NSString *sectionName;
        if ((first>='a'&&first<='z')||(first>='A'&&first<='Z')) {
            if([self searchResult:personname searchText:@"曾"])
                sectionName = @"Z";
            else if([self searchResult:personname searchText:@"解"])
                sectionName = @"X";
            else if([self searchResult:personname searchText:@"仇"])
                sectionName = @"Q";
            else if([self searchResult:personname searchText:@"朴"])
                sectionName = @"P";
            else if([self searchResult:personname searchText:@"查"])
                sectionName = @"Z";
            else if([self searchResult:personname searchText:@"能"])
                sectionName = @"N";
            else if([self searchResult:personname searchText:@"乐"])
                sectionName = @"Y";
            else if([self searchResult:personname searchText:@"单"])
                sectionName = @"S";
            else
                sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([personname characterAtIndex:0])] uppercaseString];
        }
        else {
            sectionName=[[NSString stringWithFormat:@"%c",'#'] uppercaseString];
        }
        
        [[sectionDic objectForKey:sectionName] addObject:(__bridge id)(record)];
        [contactDic setObject:(__bridge id)(record) forKey:[NSNumber numberWithInt:recordID]];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        // iOS 6 and later
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (granted){
                //---- codes here when user allow your app to access theirs' calendar.
                //[self performCalendarActivity:eventStore withDict:options];
            }else
            {
                //----- codes here when user NOT allow your app to access the calendar.
            }
        }];
    }

    
    self.view.frame = CONTENT_VIEW_FRAME;
    self.view.top = 0;
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 20, 320, 44)];
//    _searchBar.delegate = self;
    searchBar.placeholder = @"输入字母、汉字或电话号码搜索";
    
    _searchdispalyCtrl = [[UISearchDisplayController  alloc] initWithSearchBar:searchBar contentsController:self];
    
    _searchdispalyCtrl.active = NO;
    
    _searchdispalyCtrl.delegate = self;
    
    _searchdispalyCtrl.searchResultsDelegate=self;
    
    _searchdispalyCtrl.searchResultsDataSource = self;
    
    [self.view addSubview:_searchdispalyCtrl.searchBar];
//     [self setMySearchDisplayController:searchdispalyCtrl];
    
    
    self.title = @"联系人";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self loadContacts];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.searchDisplayController isActive]) {
        [self loadContacts];
        [self.tableView reloadData];
    }
    [self.searchDisplayController.searchResultsTableView reloadData];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
//显示群组
-(void)showGroupView
{
    //    GroupViewController *groupView=[[GroupViewController alloc] initWithNibName:@"GroupViewController" bundle:nil];
    //    [self.navigationController pushViewController:groupView animated:YES];
    //    [groupView release];
}

#pragma mark ABNewPersonViewControllerDelegate methods
// Dismisses the new-person view controller.
//- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
//{
//	[self dismissModalViewControllerAnimated:YES];
//}

#pragma mark ABPersonViewControllerDelegate methods
// Does not allow users to perform default actions such as dialing a phone number, when they select a contact property.
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person
					property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
	return NO;
}


#pragma mark - Table View
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.tableView]) {
        NSMutableArray *indices = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
        for (int i = 0; i < 27; i++)
            [indices addObject:[[ALPHA substringFromIndex:i] substringToIndex:1]];
        //[indices addObject:@"\ue057"]; // <-- using emoji
        return indices;
    }
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (title == UITableViewIndexSearch)
	{
		[self.tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
		return -1;
	}
    
    return  [ALPHA rangeOfString:title].location;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.tableView]) {
        return 27;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView]) {
        NSString *key=[NSString stringWithFormat:@"%c",[ALPHA characterAtIndex:section]];
        return  [[sectionDic objectForKey:key] count];
    }
    return [filteredArray count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return nil;
    }
    NSString *key=[NSString stringWithFormat:@"%c",[ALPHA characterAtIndex:section]];
    if ([[sectionDic objectForKey:key] count]!=0) {
        return key;
    }
    return nil;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (![tableView isEqual:self.tableView]) {
        //搜索结果
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        NSDictionary *person=[filteredArray objectAtIndex:indexPath.row];
        cell.textLabel.text=[person objectForKey:@"name"];
        cell.detailTextLabel.text=[person objectForKey:@"phone"];
    }
    else {
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSString *key=[NSString stringWithFormat:@"%c",[ALPHA characterAtIndex:indexPath.section]];
        NSMutableArray *persons=[sectionDic objectForKey:key];
        ABRecordRef record=(__bridge ABRecordRef)([persons objectAtIndex:indexPath.row]);
        cell.textLabel.text=(__bridge NSString *)ABRecordCopyCompositeName(record);
        //        NSData *imageData=(NSData*)ABPersonCopyImageData(record);
        //
        //        [cell.imageView setImage:[UIImage imageWithData:imageData]];
        //         cell.imageView.contentMode=UIViewContentModeScaleToFill;
    }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    ABRecordRef person;
    if (![tableView isEqual:self.tableView]) {
        NSMutableDictionary *record=[filteredArray objectAtIndex:indexPath.row];
        NSString *recordID=[record objectForKey:@"ID"];
        person=(__bridge ABRecordRef)([contactDic objectForKey:recordID]);
        
        
    }
    else {
        NSString *key=[NSString stringWithFormat:@"%c",[ALPHA characterAtIndex:indexPath.section]];
        NSMutableArray *persons=[sectionDic objectForKey:key];
        person=(__bridge ABRecordRef)([persons objectAtIndex:indexPath.row]);
    }
    
    PersonViewController* personVC = [[PersonViewController alloc]initWithPerson:person];
    
    EZNavigationController* navi = [EZinstance instanceWithKey:K_NAVIGATIONCTL];
    [navi pushViewController:personVC];
//    ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
////    picker.personViewDelegate = self;
//    picker.displayedPerson = person;
////    picker.allowsActions=YES;
////    picker.shouldShowLinkedPeople = YES;
//    // Allow users to edit the person’s information
////    picker.allowsEditing = YES;
//    if (_delegate && [_delegate respondsToSelector: @selector(clickABPerson:)]) {
//        [_delegate clickABPerson:picker];
//    }
}
#pragma UISearchDisplayDelegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self performSelectorOnMainThread:@selector(searchWithString:) withObject:searchString waitUntilDone:YES];
    
    return YES;
}
-(void)searchWithString:(NSString *)searchString
{
    [filteredArray removeAllObjects];
    NSString * regex        = @"(^[0-9]+$)";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([searchString length]!=0) {
        if ([pred evaluateWithObject:searchString]) { //判断是否是数字
            if (searchString.length < 3) {
                return;
            }
            NSArray *phones=[phoneDic allKeys];
            for (NSString *phone in phones) {
                if ([self searchResult:phone searchText:searchString]) {
                    ABRecordRef person=(__bridge ABRecordRef)([phoneDic objectForKey:phone]);
                    ABRecordID recordID=ABRecordGetRecordID(person);
                    NSString *ff=[NSString stringWithFormat:@"%d",recordID];
                    
                    NSString *name=(__bridge NSString *)ABRecordCopyCompositeName(person);
                    NSMutableDictionary *record=[[NSMutableDictionary alloc] init];
                    [record setObject:name forKey:@"name"];
                    [record setObject:[phone substringToIndex:(phone.length-ff.length)] forKey:@"phone"];
                    [record setObject:[NSNumber numberWithInt:recordID] forKey:@"ID"];
                    [filteredArray addObject:record];
                    NSLog(@"%@",filteredArray);
                }
            }
        }
        else {
            //搜索对应分类下的数组
            NSString *sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([searchString characterAtIndex:0])] uppercaseString];
            NSArray *array=[sectionDic objectForKey:sectionName];
            for (int j=0;j<[array count];j++) {
                ABRecordRef person=(__bridge ABRecordRef)([array objectAtIndex:j]);
                NSString *name=(__bridge NSString *)ABRecordCopyCompositeName(person);
                if ([self searchResult:name searchText:searchString]) { //先按输入的内容搜索
                    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
                    NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, 0);
                    ABRecordID recordID=ABRecordGetRecordID(person);
                    NSMutableDictionary *record=[[NSMutableDictionary alloc] init];
                    [record setObject:name forKey:@"name"];
                    [record setObject:personPhone forKey:@"phone"];
                    [record setObject:[NSNumber numberWithInt:recordID] forKey:@"ID"];
                    [filteredArray addObject:record];
                }
                else { //按拼音搜索
                    NSString *string = @"";
                    NSString *firststring=@"";
                    for (int i = 0; i < [name length]; i++)
                    {
                        if([string length] < 1)
                            string = [NSString stringWithFormat:@"%@",
                                      [POAPinyin quickConvert:[name substringWithRange:NSMakeRange(i,1)]]];
                        else
                            string = [NSString stringWithFormat:@"%@%@",string,
                                      [POAPinyin quickConvert:[name substringWithRange:NSMakeRange(i,1)]]];
                        if([firststring length] < 1)
                            firststring = [NSString stringWithFormat:@"%c",
                                           pinyinFirstLetter([name characterAtIndex:i])];
                        else
                        {
                            if ([name characterAtIndex:i]!=' ') {
                                firststring = [NSString stringWithFormat:@"%@%c",firststring,
                                               pinyinFirstLetter([name characterAtIndex:i])];
                            }
                            
                        }
                    }
                    if ([self searchResult:string searchText:searchString]
                        ||[self searchResult:firststring searchText:searchString])
                    {
                        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
                        NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, 0);
                        ABRecordID recordID=ABRecordGetRecordID(person);
                        NSMutableDictionary *record=[[NSMutableDictionary alloc] init];
                        [record setObject:name forKey:@"name"];
                        [record setObject:personPhone forKey:@"phone"];
                        [record setObject:[NSNumber numberWithInt:recordID] forKey:@"ID"];
                        [filteredArray addObject:record];
                        
                    }
                }
            }
        }
    }
}
-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    
}
-(BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT{
	NSComparisonResult result = [contactName compare:searchT options:NSCaseInsensitiveSearch
											   range:NSMakeRange(0, searchT.length)];
	if (result == NSOrderedSame)
		return YES;
	else
		return NO;
}

@end
