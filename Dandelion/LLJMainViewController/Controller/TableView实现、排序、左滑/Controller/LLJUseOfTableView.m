//
//  LLJUseOfTableView.m
//  Dandelion
//
//  Created by 刘帅 on 2019/11/11.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import "LLJUseOfTableView.h"
#import "LLJTableViewCell.h"

typedef NS_ENUM(NSUInteger, WSelectType) {
    WSelectTypeDelet,         //删除
    WSelectTypeEdit,          //编辑
    WSelectTypeSyn,           //同步
};

@interface LLJUseOfTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *tableViewSource;
@property (nonatomic, strong) LLJFTableView *mytableView;
@property (nonatomic) WSelectType seletType;            //操作状态
@property (nonatomic, strong) NSIndexPath *indexPath;   //正在编辑的cell

@end

@implementation LLJUseOfTableView

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
}

- (void)buttonClick:(UIButton *)sender{
    if (sender.selected) {
        self.mytableView.editing = YES;
    }else{
        self.mytableView.editing = NO;
    }
    sender.selected = !sender.selected;
    [self.mytableView reloadData];
}

#pragma mark - UI -
- (void)createUI{
    
    /* 本页功能点：
     * 1.左滑删除和编辑功能可设置图片(此方法最好在ios11以后使用 11以前建议使用纯文字设置)；
     * 2.cell排序(本页使用的是系统方法排序，在collectionview中会展示长按自定义拖动排序)
     * 3.cell设置间距（4中方法 在下面，本页展示的是第4种方法）
     */
    
    //
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"排序" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 20);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.view addSubview:self.mytableView];
    
    //排序开启编辑状态   左滑时关闭编辑状态
    //self.mytableView.editing = YES;
    [self buttonClick:button];
    
    self.mytableView.delegate = self;
    self.mytableView.dataSource = self;
}

#pragma mark - UITableView代理实现 -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableViewSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return LLJD_Y(60);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LLJTableViewCell *TableViewCel = [tableView dequeueReusableCellWithIdentifier:@"TableViewCel"];
    if (!TableViewCel) {
        TableViewCel = [[LLJTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
        TableViewCel.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [TableViewCel setupContentWithModel:self.tableViewSource[indexPath.row]];
    return TableViewCel;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了cell");
}

#pragma mark - UITableView排序 -
// 设置 cell 是否允许移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// 移动 cell 时触发
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 移动cell之后更换数据数组里的循序
    if (sourceIndexPath.row > destinationIndexPath.row) {
        for (NSInteger i = sourceIndexPath.row; i > destinationIndexPath.row; i --) {
            [self.tableViewSource exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
        }
    }else if (sourceIndexPath.row < destinationIndexPath.row){
        for (NSInteger i = sourceIndexPath.row; i < destinationIndexPath.row; i ++) {
            [self.tableViewSource exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
        }
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mytableView.editing)
    {
        for (UIView * view in cell.subviews)
        {
            if ([NSStringFromClass([view class]) rangeOfString: @"UITableViewCellReorderControl"].location != NSNotFound)
            {
                for (UIView * subview in view.subviews) {
                    if ([subview isKindOfClass: [UIImageView class]])
                    {
                        //重新设置排序按钮的frame  (其实x和y无法改变只能改变w和h)
                        CGFloat X = subview.frame.origin.x;
                        CGFloat Y = subview.frame.origin.y;
                        CGFloat W = 18;
                        CGFloat H = 12;
                        
                        subview.frame = CGRectMake(X, Y, W, H);
                        ((UIImageView *)subview).image = [UIImage imageNamed: @"sort_move"];
                    }
                }
            }
        }
    }
}


#pragma mark - 左滑删除等 -
// *左滑重新布局 如不需要使用图片 可以将一下两个方法注释掉改使用纯文字
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (IS_VALID_ARRAY(self.tableViewSource)) {
        if (self.indexPath.row <= self.tableViewSource.count - 1) {
            [self configSwipeButtons:self.indexPath source:self.tableViewSource[self.indexPath.row]];
        }
    }
}

- (void)configSwipeButtons:(NSIndexPath *)indexPath source:(LLJCommenModel *)model{
    // 获取选项按钮的reference
    if (SYSTEM_VERSION_GRETER_THAN(@"11.0")){
        
        if (SYSTEM_VERSION_GRETER_THAN(@"13.0")) {
            //iOS 13层级 : UITableView -> UISwipeActionPullView
            for (UIView *subview in self.mytableView.subviews){
                //这里写大于等于2是因为我这里需要两个action
                if ([subview isKindOfClass:NSClassFromString(@"_UITableViewCellSwipeContainerView")]){
                    //和iOS 10的按钮顺序相反
                    
                    for (UIView *sub in subview.subviews){
                        //这里写大于等于2是因为我这里需要两个action
                        if ([sub isKindOfClass:NSClassFromString(@"UISwipeActionPullView")]){
                            sub.layer.masksToBounds = YES;
                            //和iOS 10的按钮顺序相反
                            UIButton *deleteButton = sub.subviews[1];
                            [deleteButton setImage:[UIImage imageNamed:@"list_delete"] forState:UIControlStateNormal];
                            
                            UIButton *editButton = sub.subviews[0];
                            [editButton setImage:[UIImage imageNamed:@"list_edit"] forState:UIControlStateNormal];
                        }
                    }
                }
            }
        }else{
            //iOS 11层级 : UITableView -> UISwipeActionPullView
            for (UIView *subview in self.mytableView.subviews){
                //这里写大于等于2是因为我这里需要两个action
                if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")]){
                    subview.layer.masksToBounds = YES;
                    //和iOS 10的按钮顺序相反
                    UIButton *deleteButton = subview.subviews[1];
                    [deleteButton setImage:[UIImage imageNamed:@"list_delete"] forState:UIControlStateNormal];
                    
                    UIButton *editButton = subview.subviews[0];
                    [editButton setImage:[UIImage imageNamed:@"list_edit"] forState:UIControlStateNormal];
                }
            }
        }
    }else{
        // iOS 8-10层级: UITableView -> UITableViewCell -> UITableViewCellDeleteConfirmationView
        LLJTableViewCell *tableCell = [self.mytableView cellForRowAtIndexPath:indexPath];
        for(UIView *subview in tableCell.subviews){
            if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]){
                
                subview.layer.masksToBounds = YES;

                UIButton *deleteButton = subview.subviews[1];
                [deleteButton setImage:[UIImage imageNamed:@"list_delete"] forState:UIControlStateNormal];
                
                UIButton *editButton = subview.subviews[0];
                [editButton setImage:[UIImage imageNamed:@"list_edit"] forState:UIControlStateNormal];
            }
        }
    }
}

//cell左滑开始编辑
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath*)indexPath{
    
    self.indexPath = indexPath;
    [self.view setNeedsLayout];
}
- (NSArray *)tableView:(UITableView* )tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建左滑action
    return [self createMyRowAction:self.tableViewSource[indexPath.row]];
}
- (NSArray *)createMyRowAction:(LLJCommenModel *)model{
    
    //在这里根据模型条件选择每行需要的action
    NSMutableArray *array = [NSMutableArray array];
    if (/* DISABLES CODE */ (1)) {
        [array addObject:[self getRowAction:WSelectTypeDelet color:LLJColor(230, 92, 92, 1) source:model]];
        [array addObject:[self getRowAction:WSelectTypeEdit color:LLJColor(24, 134, 254, 1) source:model]];
    }else{
        [array addObject:[self getRowAction:WSelectTypeEdit color:LLJColor(24, 134, 254, 1) source:model]];
    }
    return array;
}
- (UITableViewRowAction *)getRowAction:(WSelectType)type color:(UIColor *)color source:(LLJCommenModel *)model{
    
    LLJWeakSelf(self);
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //按钮事件
        [weakSelf actionClick:type source:model];
    }];
    rowAction.backgroundColor = color;
    return rowAction;
}
- (void)actionClick:(WSelectType)type source:(LLJCommenModel *)model{
    switch (type) {
        case WSelectTypeDelet:
        {
            //删除
            NSLog(@"点击了删除");
            [self.tableViewSource removeObject:model];
            [self.mytableView reloadData];
            [LLJCDHelper deleteResourceWithEntityName:@"LLJCommenModel" predicate:[NSString stringWithFormat:@"age = %@",model.age]];
        }
            break;
        case WSelectTypeEdit:
            //编辑
            NSLog(@"点击了编辑");
            break;
            
        default:
            break;
    }
}

#pragma mark - 懒加载属性 -
- (LLJFTableView *)mytableView{
    if (!_mytableView) {
        _mytableView = [[LLJFTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - LLJTopHeight) style:UITableViewStylePlain];
        _mytableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mytableView.backgroundColor = LLJColor(241, 241, 241, 1);
    }
    return _mytableView;
}
- (NSMutableArray *)tableViewSource{
    if (!_tableViewSource) {
        _tableViewSource = [NSMutableArray arrayWithArray:[LLJCDHelper getResourceWithEntityName:@"LLJCommenModel" predicate:@"name = '赞歌zzz'"]];
    }
    return _tableViewSource;
}

#pragma mark - 设置cell间距4种方法 -

//1.设置假的间距，我们在tableviewcell的contentView上添加一个view，比如让其距离上下左右的距离都是10；这个方法是最容易想到的；

//2.用UIContentView来代替tableview，然后通过下面这个函数来设置UICollectionViewCell的上下左右的间距；

//3.用分组设置组头代替

//4.重新设置的UITableViewCellframe  在cell中重写下面方法 使用此方法时排序有问题暂时不知道怎么解决 -

    //- (void)setFrame:(CGRect)frame{
    //    frame.origin.x += 0;
    //    frame.origin.y += 10;
    //    frame.size.height -= 10;
    //    frame.size.width -= 0;
    //    [super setFrame:frame];
    //}


@end
