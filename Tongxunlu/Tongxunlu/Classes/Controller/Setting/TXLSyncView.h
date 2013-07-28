//
//  TXLSyncView.h
//  Tongxunlu
//
//  Created by 吴英杰 on 13-7-28.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXLSyncView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)IBOutlet UITableView  *myTableView;
@end
