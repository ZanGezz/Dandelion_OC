//
//  BWPSaveImgAlertView.m
//  BWPensionPro
//
//  Created by 刘帅 on 2019/5/27.
//  Copyright © 2019 Beiwaionline. All rights reserved.
//

#import "BWPSaveImgAlertView.h"

@interface BWPSaveImgAlertView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic) CGFloat H;

@end

@implementation BWPSaveImgAlertView

- (instancetype)initWithFrame:(CGRect)frame itemArray:(NSArray *)item{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        _itemArray = item;
        
        _H = (item.count + 1) *LLJD_Y(50);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
        [self addSubview:button];
        self.cancelButton = button;
        //tableview
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.bounces = NO;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:tableView];
         self.tableView = tableView;
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _itemArray.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LLJD_Y(50);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [self setUpContentView:cell indexPath:indexPath];
    }
    return cell;
}
- (void)setUpContentView:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:iPhone5?12:15];
    [cell.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(cell.contentView.mas_centerX);
        make.centerY.mas_equalTo(cell.contentView.mas_centerY);
    }];
    if (indexPath.row == _itemArray.count) {
        nameLabel.text = @"取消";
        nameLabel.textColor = LLJColor(246, 100, 100, 1);
    }else{
        nameLabel.text = _itemArray[indexPath.row];
        nameLabel.textColor = LLJColor(128, 128, 128, 1);
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    !self.didSelectRow ?: self.didSelectRow(indexPath.row);
    
    [self viewHidden];
}
- (void)buttonClick{
    
    !self.didSelectRow ?: self.didSelectRow(-1);

    [self viewHidden];
}

- (void)viewShow:(UIView *)superView{
    
    [superView addSubview:self];
    
    self.cancelButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.H);
    [UIView animateWithDuration:0.35 animations:^{
        self.tableView.frame = CGRectMake(0, SCREEN_HEIGHT - self.H, SCREEN_WIDTH, self.H);
    }];
}
- (void)viewHidden{

    //移除
    [UIView animateWithDuration:0.35 animations:^{
        self.tableView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);

    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}
@end
