#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@protocol ABPersonClickDelegate <NSObject>

- (void)clickABPerson:(ABNewPersonViewController*)person;

@end

@interface ContractViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,ABPersonViewControllerDelegate>
{
    NSMutableDictionary *sectionDic;
    NSMutableDictionary *phoneDic;
    NSMutableDictionary *contactDic;
    NSMutableArray *filteredArray;
    id             _delegate;
    //NSMutableArray *contactNames;
}
//@property(nonatomic,strong)EZNavigationController  *parentNavCtl;
@property(nonatomic,strong)id                      delegate;
-(void)loadContacts;

@end
