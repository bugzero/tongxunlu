#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@protocol ABPersonClickDelegate <NSObject>

- (void)clickABPerson:(ABNewPersonViewController*)person;

@end

@interface ContractViewController : EZRootViewController<UITableViewDelegate,UISearchDisplayDelegate,UITableViewDataSource,ABPersonViewControllerDelegate>
{
    NSMutableDictionary *sectionDic;
    NSMutableDictionary *phoneDic;
    NSMutableDictionary *contactDic;
    NSMutableArray *filteredArray;
    id             _delegate;
//    UISearchBar    *_searchBar;
    UISearchDisplayController * _searchdispalyCtrl;
    //NSMutableArray *contactNames;
    UITableView    *_tableView;
}
//@property(nonatomic,strong)EZNavigationController  *parentNavCtl;
@property(nonatomic,strong)id                      delegate;
//@property(nonatomic,strong)UITableView             *_tableView;
-(void)loadContacts;

@end
