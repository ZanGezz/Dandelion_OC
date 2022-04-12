//
//  LLJGesAndAuthIDController.m
//  Dandelion
//
//  Created by 刘帅 on 2020/11/13.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJGesAndAuthIDController.h"
#import "LLJVideoPlayController.h"
#import "LLJBridgeViewController.h"
#import "FWGuideView.h"
#import "LLJMainCell.h"
#import "FWAlertView.h"

typedef NS_ENUM(NSUInteger, WSelectType) {
    WSelectTypeDelet,         //删除
    WSelectTypeEdit,          //编辑
    WSelectTypeSyn,           //同步
};

@interface LLJGesAndAuthIDController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) FWGuideView *guideView;
@property (nonatomic, strong) LLJFTableView *mytableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *imageSource;

@end

@implementation LLJGesAndAuthIDController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
}

- (void)creatUI {
    //获取本地数据
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *videoArray = [NSMutableArray array];
    self.dataSource = [NSMutableArray array];

    [self.dataSource addObjectsFromArray:[LLJHelper getFilesWithPath:LLJ_video_Path]];
    [self.dataSource addObjectsFromArray:[LLJHelper getFilesWithPath:LLJ_image_Path]];
    for (NSString *fileName in self.dataSource) {
        NSString *filePath;
        if ([fileName containsString:@"png"]) {
            filePath = [LLJ_image_Path stringByAppendingPathComponent:fileName];
            [imageArray addObject:filePath];
        }else{
            filePath = [LLJ_video_Path stringByAppendingPathComponent:fileName];
            [videoArray addObject:filePath];
        }
    }
    self.dataSource = videoArray;
    self.imageSource = imageArray;
    [self.view addSubview:self.mytableView];
    
    [self guideViewShow];
}

- (void)guideViewShow {
    //页面出现
    [FWGuideView guideViewShow:kRootView action:^{
        
    }];
}

#pragma mark - UITableViewDelegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return LLJD_Y(80);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LLJMainCell *mainCell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    if (!mainCell) {
        mainCell = [[LLJMainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
        mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *fileName = [[self.dataSource[indexPath.row] componentsSeparatedByString:@"/"] lastObject];
    [mainCell setTitleName:fileName];
    return mainCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LLJVideoPlayController *instance = [[LLJVideoPlayController alloc]init];
    instance.titleName = self.dataSource[indexPath.row];
    instance.urlString = self.dataSource[indexPath.row];
    instance.imageArray = self.imageSource;
    instance.dataArray = self.dataSource;
    [self.navigationController pushViewController:instance animated:YES];
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *path = self.dataSource[indexPath.row];
//    [LLJHelper deleteFileByPath:path];
//    [self.dataSource removeObject:path];
//    [self.mytableView reloadData];
//}

- (NSArray *)tableView:(UITableView* )tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建左滑action
    return [self createMyRowAction];
}
- (NSArray *)createMyRowAction{
    
    //在这里根据模型条件选择每行需要的action
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[self getRowAction:WSelectTypeDelet color:LLJColor(230, 92, 92, 1)]];
    [array addObject:[self getRowAction:WSelectTypeEdit color:LLJColor(24, 134, 254, 1)]];
    return array;
}
- (UITableViewRowAction *)getRowAction:(WSelectType)type color:(UIColor *)color {
    
    LLJWeakSelf(self);
    NSString *title;
    if (type == WSelectTypeDelet) {
        title = @"删除";
    } else {
        title = @"编辑";
    }
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:title handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //按钮事件
        [weakSelf actionClick:type index:indexPath];
    }];
    rowAction.backgroundColor = color;
    return rowAction;
}
- (void)actionClick:(WSelectType)type index:(NSIndexPath *)indexPath{
    switch (type) {
        case WSelectTypeDelet:
        {
            //删除
            NSLog(@"点击了删除");
            NSString *path = self.dataSource[indexPath.row];
            [LLJHelper deleteFileByPath:path];
            [self.dataSource removeObject:path];
            [self.mytableView reloadData];
            
        }
            break;
        case WSelectTypeEdit:
        {
            //编辑
            NSLog(@"点击了编辑");
            NSString *oldPath = self.dataSource[indexPath.row];
            NSArray *fileName = [self.dataSource[indexPath.row] componentsSeparatedByString:@"/"];
            [FWAlertView alertViewShowType:FWAlertTypeCheckPw sureButtonName:@"确定" title:@"修改名称" content:@"" canBeRemoved:YES sureAction:^(NSString * _Nonnull str) {
                NSString *newPath = @"";
                for (int i = 0; i < fileName.count; i ++) {
                    NSString *subString = fileName[i];
                    if (i == fileName.count - 1) {
                        newPath = [newPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",str]];
                    } else if (i > 0) {
                        newPath = [newPath stringByAppendingPathComponent:subString];
                    } else {
                        newPath = subString;
                    }
                }
                BOOL isTrue =[[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:nil];
                if (isTrue) {
                    [MBProgressHUD showMessag:@"修改成功" toView:kRootView hudModel:MBProgressHUDModeText hide:YES];
                    [self.dataSource replaceObjectAtIndex:indexPath.row withObject:newPath];
                    [self.mytableView reloadData];
                    
                }
                
            } cancelAction:^{
                            
            }];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - 懒加载属性 -
- (LLJFTableView *)mytableView{
    if (!_mytableView) {
        _mytableView = [[LLJFTableView alloc]initWithFrame:CGRectMake(0, LLJTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - LLJTopHeight) style:UITableViewStylePlain];
        _mytableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mytableView.delegate = self;
        _mytableView.dataSource = self;
        _mytableView.backgroundColor = LLJColor(241, 241, 241, 1);
    }
    return _mytableView;
}

@end
