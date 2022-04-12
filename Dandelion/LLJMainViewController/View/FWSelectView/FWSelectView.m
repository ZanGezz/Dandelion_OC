//
//  FWSelectView.m
//  SpringsCapital
//
//  Created by 刘帅 on 2020/5/13.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import "FWSelectView.h"

@interface FWSelectView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic) FWSelectType type;
@property (nonatomic) NSInteger selectRow;

@property (nonatomic) CGFloat H;

@end

@implementation FWSelectView

- (instancetype)initWithFrame:(CGRect)frame itemArray:(NSArray *)item type:(FWSelectType)type defaultSelect:(NSInteger)defaultRow{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = LLJColor(0, 0, 0, 0);
        
        _itemArray = item;
        _type = type;
        if (defaultRow < _itemArray.count) {
            _selectRow = defaultRow;
        }else{
            _selectRow = 0;
        }
        if (iPhoneX) {
            _H = item.count *LLJD_Y(50) + LLJBottomSafeHeight;
        }else{
            _H = item.count *LLJD_Y(50);
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
        [self addSubview:button];
        self.cancelButton = button;
        //tableview
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.bounces = NO;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:tableView];
         self.tableView = tableView;
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _itemArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return LLJD_Y(50);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FWSelectCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"select"];
    if (!cell) {
        cell = [[FWSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"select" type:_type];
    }
    
    NSDictionary *dic = self.itemArray[indexPath.row];
    [cell setTitle:[dic safeObjectForKey:@"title"] font:[dic safeObjectForKey:@"font"]];
    
    if (self.selectRow == indexPath.row) {
        cell.isSelected = YES;
    }else{
        cell.isSelected = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
    NSDictionary *dic = self.itemArray[indexPath.row];

    !self.didSelectRow ?: self.didSelectRow(indexPath.row,[dic safeObjectForKey:@"title"]);
    
    [self viewHidden];
}
- (void)buttonClick{
    
    [self viewHidden];
}

- (void)viewShow:(UIView *)superView{
    
    [superView addSubview:self];
    
    self.cancelButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.H);
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = LLJColor(0, 0, 0, 0.5);
        self.tableView.frame = CGRectMake(0, SCREEN_HEIGHT - self.H, SCREEN_WIDTH, self.H);
    }];
}
- (void)viewHidden{

    //移除
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
        self.backgroundColor = LLJColor(0, 0, 0, 0);

    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dealloc{
    NSLog(@"class = %@",NSStringFromClass([self class]));
}

@end
