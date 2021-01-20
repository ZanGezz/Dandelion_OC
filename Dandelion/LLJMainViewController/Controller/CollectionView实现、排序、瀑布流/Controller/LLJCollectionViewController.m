//
//  LLJCollectionViewController.m
//  Dandelion
//
//  Created by 刘帅 on 2019/11/12.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import "LLJCollectionViewController.h"
#import "LLJChanelItem.h"
#import "LLJWaterViewController.h"
#import "UIButton+WSLTitleImage.h"

@interface LLJCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    //被拖拽的item
    LLJChanelItem *_dragingItem;
    //正在拖拽的indexpath
    NSIndexPath *_dragingIndexPath;
    //目标位置
    NSIndexPath *_targetIndexPath;
    
    NSInteger imageDataIndex;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImage *addIamge;
@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation LLJCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)buttonClick:(UIButton *)sender{
    LLJWaterViewController *water = [[LLJWaterViewController alloc]init];
    water.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:water animated:YES];
}
#pragma mark - UI -
- (void)createUI{
    
    /* 本页功能点：
     * 1.瀑布流(暂未整理)
     * 2.cell自定义排序
     * 3.按钮显示图片和文字的设置
     */
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"瀑布流" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 20);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
    
    for (int i = 0; i < 20; i ++) {
        //随机颜色生成图片
        UIImage *image = [LLJHelper imageWithRenderColor:[UIColor arc4randomColor:1] renderSize:CGSizeMake(LLJD_X(108), LLJD_Y(108))];
        [self.imageArray addObject:image];
    }
    //添加加号
    [self.imageArray addObject:self.addIamge];
    
    imageDataIndex = 0;
    
    [self.view addSubview:self.collectionView];
    
    _dragingItem = [[LLJChanelItem alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, LLJD_Y(150))];
    _dragingItem.hidden = YES;
    [self.collectionView addSubview:_dragingItem];
    
    UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [recordBtn setImage:[UIImage imageNamed:@"wkf_kaishi"] forState:UIControlStateNormal];
    [recordBtn setTitle:@"长按cell排序" forState:UIControlStateNormal];
    [recordBtn setButtonStyle:WSLButtonStyleImageLeft spacing:10];
    recordBtn.backgroundColor = LLJCommenColor;
    
    [self.view addSubview:recordBtn];
    [recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(LLJTabBarHeight);
    }];
}

#pragma mark - 懒加载 -
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumInteritemSpacing = LLJD_X(10);
        flowLayout.minimumLineSpacing = LLJD_X(10);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - LLJTopHeight - LLJTabBarHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //注册Cell，必须要有
        [_collectionView registerClass:[LLJChanelItem class] forCellWithReuseIdentifier:@"XLChannelItem"];
        //添加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
        longPress.minimumPressDuration = 0.3f;
        [_collectionView addGestureRecognizer:longPress];
    }
    return _collectionView;
}
- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (UIImage *)addIamge{
    if (!_addIamge) {
        _addIamge = [UIImage imageNamed:@"add"];
    }
    return _addIamge;
}
#pragma mark LongPressMethod
-(void)longPressMethod:(UILongPressGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:_collectionView];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self dragBegin:point];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragChanged:point];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragEnd];
            break;
        default:
            break;
    }
}
//拖拽开始 找到被拖拽的item
-(void)dragBegin:(CGPoint)point{
    
    _dragingIndexPath = [self getDragingIndexPathWithPoint:point];
    if (_dragingIndexPath.row == self.imageArray.count - 1){
        return;
    }
    
    //开始拖拽
    [_collectionView bringSubviewToFront:_dragingItem];
    LLJChanelItem *item = (LLJChanelItem*)[_collectionView cellForItemAtIndexPath:_dragingIndexPath];
    item.isMoving = true;
    item.hidden = YES;
    
    UIImage *img;
    id string = [self.imageArray objectAtIndex:_dragingIndexPath.row];
    if ([string isKindOfClass:[UIImage class]]) {
        img = string;
    }else{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
        if (data) {
            img = [UIImage imageWithData:data];
        }
    }
    
    //更新被拖拽的item
    _dragingItem.hidden = false;
    _dragingItem.frame = item.frame;
    if (img) {
        UIImage *sizeImg = [LLJHelper reSizeImage:img toSize:CGSizeMake(item.bounds.size.width, item.bounds.size.height)];
        _dragingItem.contentView.backgroundColor = [UIColor colorWithPatternImage:sizeImg];
    }
    _dragingItem.imageView = item.imageView;
    
    _dragingItem.alpha = 0.75;
    [_dragingItem setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
    //NSLog(@"开始");
}

//正在被拖拽、、、
-(void)dragChanged:(CGPoint)point{
    if (!_dragingIndexPath) {return;}
    _dragingItem.center = point;
    _targetIndexPath = [self getTargetIndexPathWithPoint:point];
    //交换位置 如果没有找到_targetIndexPath则不交换位置
    if (_dragingIndexPath && _targetIndexPath) {
        //更新数据源
        [self rearrangeInUseTitles];
    }
    //NSLog(@"郑州结束");
}

//拖拽结束
-(void)dragEnd{
    if (!_dragingIndexPath) {return;}
    CGRect endFrame = [_collectionView cellForItemAtIndexPath:_dragingIndexPath].frame;
    [_dragingItem setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    [UIView animateWithDuration:0.3 animations:^{
        self->_dragingItem.frame = endFrame;
    }completion:^(BOOL finished) {
        self->_dragingItem.hidden = true;
        LLJChanelItem *item = (LLJChanelItem*)[self->_collectionView cellForItemAtIndexPath:self->_dragingIndexPath];
        item.isMoving = false;
        item.hidden = NO;
    }];
}

#pragma mark 辅助方法
//获取被拖动IndexPath的方法
-(NSIndexPath*)getDragingIndexPathWithPoint:(CGPoint)point{
    NSIndexPath* dragIndexPath = nil;
    //最后剩一个怎不可以排序
    if ([_collectionView numberOfItemsInSection:0] == 1) {return dragIndexPath;}
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        //下半部分不需要排序
        if (indexPath.section > 0) {continue;}
        //在上半部分中找出相对应的Item
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            //            if (indexPath.row != 0) {
            dragIndexPath = indexPath;
            //            }
            break;
        }
    }
    return dragIndexPath;
}

//获取目标IndexPath的方法
-(NSIndexPath*)getTargetIndexPathWithPoint:(CGPoint)point{
    NSIndexPath *targetIndexPath = nil;
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        //如果是自己不需要排序
        if ([indexPath isEqual:_dragingIndexPath]) {continue;}
        //第二组不需要排序
        if (indexPath.section > 0) {continue;}
        //在第一组中找出将被替换位置的Item
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            //            if (indexPath.row != 0) {
            targetIndexPath = indexPath;
            //            }
        }
    }
    return targetIndexPath;
}
#pragma mark -
#pragma mark 刷新方法
//拖拽排序后需要重新排序数据源
-(void)rearrangeInUseTitles
{
    if (self.imageArray.count - 1 != _targetIndexPath.row) {
        [self.imageArray exchangeObjectAtIndex:_dragingIndexPath.row withObjectAtIndex:_targetIndexPath.row];
        
        //更新item位置
        [_collectionView moveItemAtIndexPath:_dragingIndexPath toIndexPath:_targetIndexPath];
        _dragingIndexPath = _targetIndexPath;
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"XLChannelItem";
    LLJWeakSelf(self);
    LLJChanelItem * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.deletIamgeBlock = ^(NSInteger index) {
        
        [weakSelf.imageArray removeObjectAtIndex:index];
        [weakSelf.collectionView reloadData];
    };
    [cell setIamgeName:self.imageArray[indexPath.row] index:indexPath.row deletHidden:indexPath.row == self.imageArray.count -1 ? YES : NO];
    
    return cell;
}

#pragma mark- UICollectionViewDataDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@".......");
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(LLJD_X(108), LLJD_Y(108));
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(LLJD_Y(11),LLJD_X(16),LLJD_Y(10),LLJD_X(15));
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    NSLog(@"dealloc = %@",NSStringFromClass([self class]));
}

@end
