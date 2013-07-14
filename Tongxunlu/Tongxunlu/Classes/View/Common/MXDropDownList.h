@class  MXDropDownList;

#import <UIKit/UIKit.h>

@protocol MXDropDownListDelegate <NSObject>
@optional
- (BOOL)dropDownListValueWillChanged:(NSString *)selectedValue index:(int) index;
- (void)dropDownListValueChanged:(NSString *)selectedValue index:(int) index;
@end

typedef NS_ENUM(NSInteger, MXListType) {
    ForRecordList = 0,
    ForCircleList,
    ForChallenge,
    
};
typedef NS_ENUM(NSInteger, MXListTitleType) {
    TitleInTop = 0,
    TitleInbottom,
    
    
};

@interface MXDropDownList : UIView <UITableViewDataSource,UITableViewDelegate>
{
     int  _rowHeight;
     NSMutableArray  *_listData;
     NSArray *_listImages;
     UITableView *_innerTable;
     MXListType _listType;
     MXListTitleType _listTitleType;
    Boolean _isHideList;
}

@property (nonatomic, weak) id <MXDropDownListDelegate> delegate;
@property (nonatomic,assign) int nowSelectIndex;
@property (strong, nonatomic) NSArray  *listData;
@property (strong, nonatomic) NSArray  *listImages;
@property (strong, nonatomic)  UITableView *innerTable;
@property (nonatomic,assign) int rowHeight;
@property (nonatomic,assign) MXListType listType;
@property (nonatomic,assign)  Boolean isHideList;
@property (nonatomic,assign) MXListTitleType listTitleType;
- (id)initWithFrame:(CGRect)frame listData:(NSArray *)listData;
- (id)initWithFrame:(CGRect)frame;
- (id)initForCircleWithFrame:(CGRect)frame;
- (id)initForRecordWithFrame:(CGRect)frame listData:(NSArray *)listData listTitleType:(MXListTitleType)listTitleType;
- (id)initForRecordWithFrame:(CGRect)frame listData:(NSArray *)listData listTitleType:(MXListTitleType)listTitleType listImg:(NSArray *)listImg;
- (id)initWithFrame:(CGRect)frame listData:(NSArray *)listData listImages:(NSArray *)listImages;
- (void)showDropDownList;
- (void)hideDropDownList;
- (int)rowCount;
@end
