//
//  CallDetailView.m
//  Tongxunlu
//
//  Created by kongkong on 13-8-2.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "CallDetailView.h"
#import "AccountEntity.h"
#import "EZNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDate+EZ.h"

#define DETAIL_CELL_HEIGHT 50

@interface CallDetailView(){
    UIView*         _contentView;
    UITableView*    _dataView;
    UIButton*       _closeButton;
    
    NSArray*        _tableData;
}

@end

@implementation CallDetailView

-(id)initWithData:(NSArray *)dataList{
    
    if (self = [super initWithFrame:FULL_VIEW_FRAME]) {

        self.backgroundColor = RGBA(0, 0, 0, 0.7);
        [self addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        
        // content
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(20, 50, FULL_WIDTH-40, 400)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        [self adjustWithData:dataList];
        
        // title
        [self addTitleView];
        
        // tableview
        [self addTableView];
        
        // close
        [self addCloseBtn];

    }
    return self;
}

-(void)show{
    UIView* pView = ((EZNavigationController*)[EZinstance instanceWithKey:K_NAVIGATIONCTL]).view;
    [pView addSubview:self];
    
    self.alpha = 0.0f;
    [UIView animateWithDuration:EZ_ANIMATION_DURATION animations:^{
        self.alpha = 1.0f;
    }];
}

-(void)adjustWithData:(NSArray*)data{
    _tableData = [data mutableCopy];
    
    if (_tableData.count < 8) {
        CGFloat height = _tableData.count*DETAIL_CELL_HEIGHT;
        _contentView.height = 100+height;
    }
    _contentView.center = self.center;
}

-(void)addCloseBtn{
    if (_closeButton) {
        return;
    }
    _closeButton = [[UIButton alloc]initWithFrame:_contentView.bounds];
    _closeButton.height = 50;
    [_closeButton setBackgroundColor:RGB(250, 250, 250)];
    [_closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"bg_acionsheet_bar"] forState:UIControlStateHighlighted];
    
    [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    _closeButton.titleLabel.font = BOLD_FONT(18);
    [_closeButton addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    _closeButton.top = _contentView.height-_closeButton.height;

    // top    
    UIView* top = [[UIView alloc]initWithFrame:_closeButton.bounds];
    top.height = 2;
    [top shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, -3) shadowRadius:2.0f shadowOpacity:0.6];
    [_closeButton addSubview:top];
    
    // bottom
    UIView* bottom = [[UIView alloc]initWithFrame:_closeButton.bounds];
    bottom.backgroundColor = [UIColor brownColor];
    bottom.height = 3;
    bottom.top = _closeButton.height-3;
    [_closeButton addSubview:bottom];
    
    [_contentView addSubview:_closeButton];
}

-(void)addTitleView{
    UIImageView *titleView = [[UIImageView alloc]initWithFrame:_contentView.bounds];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.height = 50;
    titleView.image = [UIImage themeImageNamed:@"NavBar.png"];
    [_contentView addSubview:titleView];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:titleView.bounds];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"全部通话记录";
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.font = FONT(18);
    titleLabel.textColor = [UIColor whiteColor];
    [titleView addSubview:titleLabel];
}


-(void)addTableView{
    
    if (_dataView) {
        return;
    }
    _dataView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, _contentView.width, _contentView.height-100)];
    
    _dataView.delegate = self;
    _dataView.dataSource = self;
    [_contentView addSubview:_dataView];
}

#pragma -mark
#pragma -mark UITableViewDataSource,UITableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell  = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = FONT(15);
        cell.textLabel.textColor = RGB(94, 94, 94);
    }
    
    AccountEntity* account = nil;
    if ([indexPath row] < [_tableData count]) {
        account = _tableData[[indexPath row]];
        if (![account isKindOfClass:[AccountEntity class]]) {
            account = nil;
        }
    }
    
    if (cell && account) {
        cell.textLabel.text = [NSDate humanDateFromTimestamp:account.time];
    }
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DETAIL_CELL_HEIGHT;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableData.count;
}

@end
