//
//  LLJAlertView.m
//  Dandelion
//
//  Created by 刘帅 on 2019/12/13.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import "LLJAlertView.h"


@interface LLJAlertView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic) CGFloat H;

@end


@implementation LLJAlertView

#pragma mark - 初始化 -
- (instancetype)initWithFrame:(CGRect)frame itemArray:(NSArray *)item{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = LLJColor(0, 0, 0, 0);
        
        _itemArray = [NSMutableArray arrayWithArray:item];
        [_itemArray addObject:@"取消"];
        _rowHeight = LLJD_Y(44);
        _H = _itemArray.count *_rowHeight + LLJD_Y(10);
        
        //UI
        [self createUI];
    }
    return self;
}

#pragma mark - UI -
- (void)createUI{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    [self addSubview:button];
    self.cancelButton = button;
    //tableview
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.bounces = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:tableView];
     self.tableView = tableView;
}

#pragma mark - tableViewDelegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _itemArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _itemArray.count - 1) {
        return self.rowHeight + LLJD_Y(10);
    }
    return self.rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [self setUpContentView:cell indexPath:indexPath];
    
    return cell;
}
- (void)setUpContentView:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = LLJFont(15);
    nameLabel.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(cell.contentView.mas_right);
        make.bottom.mas_equalTo(cell.contentView.mas_bottom);
        make.left.mas_equalTo(cell.contentView.mas_left);
        make.height.mas_equalTo(self.rowHeight);
    }];
    nameLabel.text = _itemArray[indexPath.row];

    if (indexPath.row == _itemArray.count - 1) {
        cell.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = _cancelColor?_cancelColor:LLJColor(51, 51, 51, 1);
    }else{
        nameLabel.textColor = _commenColor?_commenColor:LLJColor(51, 51, 51, 1);
    }
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = LLJColor(221, 221, 221, 1);
    [cell.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(cell.contentView.mas_right);
        make.top.mas_equalTo(cell.contentView.mas_top);
        make.left.mas_equalTo(cell.contentView.mas_left);
        make.height.mas_equalTo(1);
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    !self.didSelectRow ?: self.didSelectRow(self.itemArray[indexPath.row]);
    
    [self viewHidden];
}

- (void)buttonClick{
    
    !self.didSelectRow ?: self.didSelectRow(self.cancelTitle?self.cancelTitle:@"取消");

    [self viewHidden];
}

#pragma mark - 显示view -
- (void)viewShow:(UIView *)superView{
    
    [superView addSubview:self];
    
    self.cancelButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.H);
    
    [UIView animateWithDuration:0.35 animations:^{
        self.backgroundColor = LLJColor(0, 0, 0, 0.4);    //背景透明度
        self.tableView.frame = CGRectMake(0, SCREEN_HEIGHT - self.H, SCREEN_WIDTH, self.H);
    }];
}

#pragma mark - 隐藏view -
- (void)viewHidden{

    //移除
    [UIView animateWithDuration:0.35 animations:^{
        
        self.backgroundColor = LLJColor(255, 255, 255, 0);    //背景透明度

        self.tableView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);

    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Set方法处理 -
- (void)setCommenColor:(UIColor *)commenColor{
    
    _commenColor = commenColor;
    
    [self.tableView reloadData];
}
- (void)setCancelTitle:(NSString *)cancelTitle{
    
    _cancelTitle = cancelTitle;
    [self.itemArray removeLastObject];
    [self.itemArray addObject:_cancelTitle];
    [self.tableView reloadData];
}
- (void)setCancelColor:(UIColor *)cancelColor{
    
    _cancelColor = cancelColor;
    
    [self.tableView reloadData];
}

- (void)setRowHeight:(CGFloat )rowHeight{
    
    _rowHeight = rowHeight;

    [self.tableView reloadData];
}
@end
