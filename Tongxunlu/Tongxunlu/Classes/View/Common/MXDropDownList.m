#import "MXDropDownList.h"

@implementation MXDropDownList
@synthesize rowHeight = _rowHeight;
@synthesize listData = _listData;
@synthesize listImages = _listImages;
@synthesize innerTable = _innerTable;
@synthesize listType = _listType;
@synthesize listTitleType = _listTitleType;
@synthesize isHideList = _isHideList;
@synthesize nowSelectIndex;

-(void)setListData:(NSMutableArray *)listData
{
    _listData = listData;
    [self.innerTable reloadData];
    
    
}
//- (id)initForRecordWithFrame:(CGRect)frame listData:(NSArray *)listData listTitleType:(MXListTitleType)listTitleType listImg:(NSArray *)listImg isForAddWay:(Boolean)isForAddWay
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        _isHideList = YES;
//        self.listImages = listImg;
//        self.listData =listData;
//        _listTitleType = listTitleType;
//        _listType =  ForRecordList;
//        self.backgroundColor = [[UIColor alloc]initWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
//        
//        self.innerTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, frame.size.width, frame.size.height) style:UITableViewStylePlain];
//        self.innerTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.innerTable.delegate = self;
//        self.innerTable.dataSource = self;
//        self.innerTable.bounces = NO;
//        self.innerTable.backgroundColor  = [UIColor clearColor];
//        
//        [self addSubview:self.innerTable];
//    }
//    return self;
//}
- (id)initForRecordWithFrame:(CGRect)frame listData:(NSArray *)listData listTitleType:(MXListTitleType)listTitleType listImg:(NSArray *)listImg
{
    self = [super initWithFrame:frame];
    if (self) {
        _isHideList = YES;
        self.listImages = listImg;
        self.listData =listData;
        _listTitleType = listTitleType;
        _listType =  ForRecordList;
        self.backgroundColor = [[UIColor alloc]initWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        
        self.innerTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.innerTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.innerTable.delegate = self;
        self.innerTable.dataSource = self;
        self.innerTable.bounces = NO;
        self.innerTable.backgroundColor  = [UIColor clearColor];
        
        [self addSubview:self.innerTable];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame listData:(NSArray *)listData listImages:(NSArray *)listImages
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //NSLog(@"KKDropDownList initWithFrame");
        _isHideList = YES;
        self.listData =listData;
        self.listImages = listImages;
        self.backgroundColor = [[UIColor alloc]initWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        
        self.innerTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.innerTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.innerTable.delegate = self;
        self.innerTable.dataSource = self;
        self.innerTable.bounces = NO;
        self.innerTable.backgroundColor  = [UIColor clearColor];
        
        [self addSubview:self.innerTable];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame listData:(NSArray *)listData
{
    self = [super initWithFrame:frame];
    if (self) {
        _isHideList = YES;
        // Initialization code
        //NSLog(@"KKDropDownList initWithFrame");
        
        self.listData =listData;
        self.backgroundColor = [[UIColor alloc]initWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        
        self.innerTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.innerTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.innerTable.delegate = self;
        self.innerTable.dataSource = self;
        self.innerTable.bounces = NO;
        self.innerTable.backgroundColor  = [UIColor clearColor];
        
        [self addSubview:self.innerTable];
    }
    return self;
}
-(id)initForRecordWithFrame:(CGRect)frame listData:(NSArray *)listData listTitleType:(MXListTitleType)listTitleType
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [super initWithFrame:frame];
        if (self) {
            _isHideList = YES;
            // Initialization code
            //NSLog(@"KKDropDownList initWithFrame");
            _listType = ForRecordList;
            _listTitleType = listTitleType;
            self.listData = listData;
            self.backgroundColor = [[UIColor alloc]initWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
            
            self.innerTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
            self.innerTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.innerTable.delegate = self;
            self.innerTable.dataSource = self;
            self.innerTable.bounces = NO;
            self.innerTable.backgroundColor  = [UIColor clearColor];
            
            [self addSubview:self.innerTable];
        }
//        return self;
    }
    return self;
}

-(id)initForCircleWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [super initWithFrame:frame];
        if (self) {
            _isHideList = YES;
            // Initialization code
            //NSLog(@"KKDropDownList initWithFrame");
            _listType = ForCircleList;
             self.listData = [NSArray arrayWithObjects:@"创建圈子",nil];
            //self.listData = [NSArray arrayWithObjects:@"所有圈子",@"圈子排行榜",@"我加入的",@"我创建的",@"创建圈子",nil];
            self.backgroundColor = [[UIColor alloc]initWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
            
            self.innerTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
            self.innerTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.innerTable.delegate = self;
            self.innerTable.dataSource = self;
            self.innerTable.bounces = NO;
            self.innerTable.backgroundColor  = [UIColor clearColor];
            
            [self addSubview:self.innerTable];
        }
//        return self;
    }
    
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isHideList = YES;
        //NSLog(@"KKDropDownList initWithFrame");
        
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.backgroundColor = [[UIColor alloc]initWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        
        self.listData = [NSArray arrayWithObjects:@"全部记录",@"朋友",@"同事",nil];
        
        self.innerTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.innerTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.innerTable.delegate = self;
        self.innerTable.dataSource = self;
        self.innerTable.backgroundColor  = [UIColor clearColor];
        
        [self addSubview:self.innerTable];
    }
    return self;
}
-(int) rowCount
{
    return _listData.count;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}


-(void) setRowHeight:(int)rowHeight
{
    _rowHeight = rowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier;
    UITableViewCell *cell ;
    if (self.listImages.count > 0) {
        CellIdentifier = @"DropDownCellWithImage";
    }
    else
    {
        CellIdentifier = @"DropDownCell";
    }
    
    switch (_listType) {
        case ForRecordList:
            if (self.listImages.count > 0) {
                
                if (_listTitleType == TitleInbottom) {
                    
                    
                    
                    // static NSString *CellIdentifier = @"DropDownCellWithImage";
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if(cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier
                                                                     :CellIdentifier];
                    }
                    
                    cell.textLabel.backgroundColor = [UIColor clearColor];
                    
                    if (self.listImages.count >= indexPath.row+1) {
                        
                        cell.imageView.image = [self.listImages objectAtIndex:indexPath.row];
                    }
                    cell.textLabel.text = [self.listData objectAtIndex:[indexPath row]];
                    
                    
                    cell.textLabel.font = [UIFont systemFontOfSize:14];
                    
                    if ([indexPath row]%2==0) {
                        cell.contentView.backgroundColor = kColorDrowpDownFirstRow;
                    }else{
                        cell.contentView.backgroundColor = kColorDrowpDownSecondRow;
                    }
                    if (indexPath.row == (_listData.count-1)) {
                        cell.contentView.backgroundColor = kColorDrowpDownLastRow;
                    }
                }
                else
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if(cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier
                                                                     :CellIdentifier];
                    }
                    
                    cell.textLabel.backgroundColor = [UIColor clearColor];
                    
                    if (self.listImages.count >= indexPath.row+1) {
                        
                        cell.imageView.image = [self.listImages objectAtIndex:indexPath.row];
                    }
                    cell.textLabel.text = [self.listData objectAtIndex:[indexPath row]];
                    
                    
                    cell.textLabel.font = [UIFont systemFontOfSize:14];
                    
                    if ([indexPath row]%2==0) {
                        cell.contentView.backgroundColor = kColorDrowpDownFirstRow;
                    }else{
                        cell.contentView.backgroundColor = kColorDrowpDownSecondRow;
                    }
                    if (indexPath.row == 0) {
                          cell.contentView.backgroundColor = kColorDrowpDownLastRow;
                    }

                }
                
                
              
                
            }else
            {
                
                
                if (_listTitleType == TitleInbottom) {
                    
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if(cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier
                                                                     :CellIdentifier];
                    }
                    
                    if ([indexPath row]==[tableView numberOfRowsInSection:0]-1) {
                        cell.textLabel.text = [self.listData objectAtIndex:[indexPath row]];
                        cell.textLabel.font = [UIFont systemFontOfSize:10.0];
                        cell.textLabel.textColor = [UIColor darkGrayColor];
                        cell.contentView.backgroundColor = kColorDrowpDownLastRow;
                    }else{
                        
                       
                        cell.textLabel.text = [self.listData objectAtIndex:[indexPath row]];
                        
                        
                        cell.textLabel.font = [UIFont systemFontOfSize:14];
                        if ([indexPath row]%2==0) {
                            cell.contentView.backgroundColor = kColorDrowpDownFirstRow;
                        }else{
                            cell.contentView.backgroundColor = kColorDrowpDownSecondRow;
                        }
                        
                    }
                    
                }else
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if(cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier
                                                                     :CellIdentifier];
                    }
                    cell.textLabel.backgroundColor = [UIColor clearColor];
                    
                    if ([indexPath row] == 0) {
                        
                        cell.textLabel.text = [self.listData objectAtIndex:[indexPath row]];
                        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
                        cell.contentView.backgroundColor = kColorDrowpDownLastRow;
                        
                    }else{
                        
                        cell.textLabel.text = [self.listData objectAtIndex:[indexPath row]];
                        
                        
                        cell.textLabel.font = [UIFont systemFontOfSize:14];
                        if ([indexPath row]%2==0) {
                            cell.contentView.backgroundColor = kColorDrowpDownFirstRow;
                        }else{
                            cell.contentView.backgroundColor = kColorDrowpDownSecondRow;
                        }
                        
                    }
                    
                }
                
                
                
                
            }
            break;
        case ForCircleList:
            
            
            if (self.listImages.count > 0) {
                
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier
                                                                 :CellIdentifier];
                }
                cell.textLabel.backgroundColor = [UIColor clearColor];
                
                if (self.listImages.count >= indexPath.row+1) {
                    
                    cell.imageView.image = [self.listImages objectAtIndex:indexPath.row];
                }
                cell.textLabel.text = [self.listData objectAtIndex:[indexPath row]];
                
                
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                
                if ([indexPath row]%2==0) {
                    cell.contentView.backgroundColor = kColorDrowpDownFirstRow;
                }else{
                    cell.contentView.backgroundColor = kColorDrowpDownSecondRow;
                }
                
            }else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier
                                                                 :CellIdentifier];
                }
                cell.textLabel.backgroundColor = [UIColor clearColor];
                if ([indexPath row]==[tableView numberOfRowsInSection:0]-1) {
                    
                    UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
                    cellView.backgroundColor = kColorDrowpDownLastRow;
                    
                    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(160-20, 22-5, 40, 10)];
                    textLabel.backgroundColor = [UIColor clearColor];
                    textLabel.text = [self.listData objectAtIndex:[indexPath row]];
                    textLabel.font = [UIFont systemFontOfSize:10.0];
                    textLabel.textColor = [UIColor whiteColor];
                    [cellView addSubview:textLabel];
                    [cell addSubview:cellView];
                }else{
                    
                    cell.textLabel.text = [self.listData objectAtIndex:[indexPath row]];
                    
                    
                    cell.textLabel.font = [UIFont systemFontOfSize:14];
                    if ([indexPath row]%2==0) {
                        cell.contentView.backgroundColor = kColorDrowpDownFirstRow;
                    }else{
                        cell.contentView.backgroundColor = kColorDrowpDownSecondRow;
                    }
                }
                
                
            }
            
            
            break;
        case ForChallenge:
            
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier
                                                             :CellIdentifier];
            }            cell.textLabel.backgroundColor = [UIColor clearColor];
            
            
            cell.textLabel.text = [self.listData objectAtIndex:[indexPath row]];
            
            
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            
            if ([indexPath row]%2==0) {
                cell.contentView.backgroundColor = kColorDrowpDownFirstRow;
            }else{
                cell.contentView.backgroundColor = kColorDrowpDownSecondRow;
            }
            
            break;
        default:
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier
                                                             :CellIdentifier];
            }
            cell.textLabel.backgroundColor = [UIColor clearColor];
            
            
            cell.textLabel.text = [self.listData objectAtIndex:[indexPath row]];
            
            
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            
            if ([indexPath row]%2==0) {
                cell.contentView.backgroundColor = kColorDrowpDownFirstRow;
            }else{
                cell.contentView.backgroundColor = kColorDrowpDownSecondRow;
            }
            break;
    }
    
    
    
    return cell;
}

- (void)showDropDownList
{
    _isHideList = NO;
    self.alpha = 0.0;
    self.hidden = NO;
    //开始动画
    [UIView beginAnimations:nil context:nil];
    self.alpha = 1.0;
    //设定动画持续时间
    [UIView setAnimationDuration:2];
    //动画的内容
    //动画结束
    [UIView commitAnimations];
    
    
}
- (void)hideDropDownList;
{
    _isHideList = YES;
    self.alpha = 1.0;
    //开始动画
    [UIView beginAnimations:nil context:nil];
    self.alpha = 0.0;
    //设定动画持续时间
    [UIView setAnimationDuration:2000];
    //动画的内容
    //动画结束
    [UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:1000 target:self selector:@selector(thisHide) userInfo:nil repeats:NO];
    
}
-(void)thisHide
{
    self.hidden = YES;
}
#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL shouldLoad = YES;
    if ([indexPath row]==[tableView numberOfRowsInSection:0]) {
        
    }else{
        if ([self.delegate respondsToSelector:@selector(dropDownListValueWillChanged:index:)]) {
            shouldLoad = [self.delegate dropDownListValueWillChanged:[self.listData objectAtIndex:[indexPath row]]index:[indexPath row]];
        }
        
        if (shouldLoad) {
            nowSelectIndex = indexPath.row;
            if ([self.delegate respondsToSelector:@selector(dropDownListValueChanged:index:)]) {
                [self.delegate dropDownListValueChanged:[self.listData objectAtIndex:[indexPath row]]index:[indexPath row]];
            }
        }
    }
    
    if (shouldLoad) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
