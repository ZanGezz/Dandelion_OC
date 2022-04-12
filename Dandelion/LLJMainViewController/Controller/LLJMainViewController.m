//
//  LLJMainViewController.m
//  Dandelion
//
//  Created by 刘帅 on 2019/7/17.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import "LLJMainViewController.h"
#import "SRAlbumViewController.h"
#import "BWPSourceSelectView.h"
//controller
#import "LLJCircleOfFriendController.h"
#import "LLJDataSaveViewController.h"
#import "LLJNaviController.h"
#import "LLJFViewController.h"
//cell
#import "LLJMainCell.h"
#import <CoreText/CoreText.h>

@interface LLJMainViewController ()<UITableViewDelegate,UITableViewDataSource,SRAlbumViewControllerDelegate>

//@property(nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic, strong) LLJFTableView *mytableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic) CGFloat naviAlpha;

@property (nonatomic, strong) UILabel *label;

@end

@implementation LLJMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

#pragma mark - 通知事件 -
- (void)centerBtnClick:(NSNotification *)noti{
    
    NSDictionary *dic = noti.object;
    NSString *type = [dic objectForKey:@"type"];
    NSString *name = [dic objectForKey:@"obj"];
    NSLog(@"中间按钮点击 - %@ = %@",type,name);
    
    [self addGuanjiaShareView];
}

- (void)scrollToTop{
    //滚动到顶部
    [self.mytableView scrollToViewTop];
}

#pragma mark - 滑动改变导航栏颜色 -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //动态改变导航view透明度
    self.naviAlpha = scrollView.contentOffset.y/LLJTopHeight;
    if (self.naviAlpha < 0.0) {
        self.naviAlpha = 0.0;
    }else if (self.naviAlpha >= 0.5){
        self.naviAlpha = 0.5;
    }
    //修改导航栏颜色
    //LLJNaviController *navi = (LLJNaviController *)self.navigationController;
    //[navi setUpBackGroundColor:LLJColor(0, 0, 0, 1 - self.naviAlpha)];
}

- (NSArray *)getLocalResource:(NSString *)name {
    
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:nil];
    return [LLJHelper getSetWithJsonString:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil]];
}

- (void)buttonClick:(UIButton *)sender{
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"沾沾" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"zhanzha" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    UIAlertController *controler = [UIAlertController alertControllerWithTitle:@"渣渣" message:@"我们都是好孩子" preferredStyle:UIAlertControllerStyleAlert];
    controler.view.layer.zPosition = 1.0;
    [controler addAction:action];
    [controler addAction:action1];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controler animated:YES completion:nil];
    
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"挡住你！！！" toView:kRootView hudModel:MBProgressHUDModeText hide:NO];
    hud.userInteractionEnabled = YES;
    
    [kRootView bringSubviewToFront:sender];
    NSLog(@"dian ji le top view");
}

#pragma mark - UI -
- (void)createUI{

    //防止tableView从状态栏下方开始
    if (@available(iOS 11.0, *)) {
        self.mytableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = LLJColor(241, 241, 241, 1);
    //获取本地数据
    self.dataArray = [self getLocalResource:@"LLJSourceMain.txt"];

    [self.view addSubview:self.mytableView];
    
    //中间按钮响应事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(centerBtnClick:) name:@"centerBtnClick" object:nil];
    //双击tabbar Tableview回到顶部
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToTop) name:@"scrollToTop" object:nil];
}
#pragma mark - UITableViewDelegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
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
    [mainCell setTitleName:self.dataArray[indexPath.row]];
    return mainCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *viewController = [[(NSString *)self.dataArray[indexPath.row] componentsSeparatedByString:@":"] lastObject];
    Class class = NSClassFromString(viewController);
    LLJFViewController *instance = [[class alloc]init];
    instance.titleName = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:instance animated:YES];
}

#pragma mark - 懒加载属性 -
- (LLJFTableView *)mytableView{
    if (!_mytableView) {
        _mytableView = [[LLJFTableView alloc]initWithFrame:CGRectMake(0, LLJTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - LLJTopHeight - LLJTabBarHeight) style:UITableViewStylePlain];
        _mytableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mytableView.delegate = self;
        _mytableView.dataSource = self;
        _mytableView.backgroundColor = LLJColor(241, 241, 241, 1);
    }
    return _mytableView;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//#pragma mark - dataSouce
////有几行
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    return self.dataSource.count;
//}
////行中有几列
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    return [self.dataSource[component] count];
//}
////列显示的数据
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger) row forComponent:(NSInteger)component {
//    return self.dataSource[component][row];
//}
//- (UIPickerView *)pickerView {
//    if (!_pickerView) {
//        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 320)];
//        _pickerView.delegate = self;
//        _pickerView.dataSource = self;
//    }
//    return _pickerView;
//
//}

#pragma mark - 选择添加资源 -
- (void)addGuanjiaShareView {
    NSArray *shareAry = @[@{@"image":@"home_tan_01",
                            @"title":@"拍摄照片"},
                          @{@"image":@"home_tan_02",
                            @"title":@"拍摄视频"},
                          @{@"image":@"home_tan_03",
                            @"title":@"本地照片"},
                          @{@"image":@"home_tan_04",
                            @"title":@"本地视频"},
                          @{@"image":@"home_tan_05",
                            @"title":@"语音"},
                          @{@"image":@"home_tan_06",
                            @"title":@"寄语"},
                          ];

    BWPSourceSelectView *shareView = [[BWPSourceSelectView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    shareView.backView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    float height = [shareView getBoderViewHeight:shareAry firstCount:4];
    shareView.boderView.frame = CGRectMake(0, 0, shareView.frame.size.width, height);
    shareView.middleLineLabel.hidden = YES;
    shareView.cancleButton.frame = CGRectMake(shareView.cancleButton.frame.origin.x, shareView.cancleButton.frame.origin.y, shareView.cancleButton.frame.size.width, 54);
    shareView.cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [shareView setShareAry:shareAry delegate:self];
    [kRootView addSubview:shareView];
}

#pragma mark - BWPSourceSelectViewDelegate -
- (void)easyCustomShareViewButtonAction:(BWPSourceSelectView *)shareView title:(NSString *)title{
    if ([title isEqualToString:@"拍摄照片"]) {

        [self goToCamera:SRDeviceTypeCamera assetType:SRAssetTypePic maxItem:9];
    }else if ([title isEqualToString:@"拍摄视频"]){

        [self goToCamera:SRDeviceTypeCamera assetType:SRAssetTypeVideo maxItem:1];

    }else if ([title isEqualToString:@"本地照片"]){

        [self goToCamera:SRDeviceTypeLibrary assetType:SRAssetTypePic maxItem:900];

    }else if ([title isEqualToString:@"本地视频"]){

        [self goToCamera:SRDeviceTypeLibrary assetType:SRAssetTypeVideo maxItem:100];

    }else if ([title isEqualToString:@"语音"]){

        [self goToCamera:SRDeviceTypeAudio assetType:SRAssetTypeVideo maxItem:1];
    }else{
        NSDictionary *dic = @{@"type":@"text",@"obj":@[]};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"readyUpload" object:dic];
    }
}

#pragma mark - 拍照摄像 -
- (void)goToCamera:(SRDeviceType)deviceType assetType:(SRAssetType)assetType maxItem:(NSInteger)maxitem{

    SRAlbumViewController *vc = [[SRAlbumViewController alloc] initWithDeviceType:deviceType];
    vc.albumDelegate = self;
    vc.assetType = assetType;
    vc.maxItem = maxitem;
    vc.maxlength = 500*1024;
    vc.isEidt = NO;
    vc.isShowPicList = YES;
    [self presentViewController:vc animated:YES completion:nil];
}
/**
 TODO:相册视频获取

 @param picker 相册
 @param vedios 视频列表
 */
- (void)srAlbumPickerController:(SRAlbumViewController *)picker didFinishPickingVedios:(NSArray *)vedios {
    NSLog(@"video = %@",vedios);
}

/**
 TODO:相册照片获取

 @param picker 相册
 @param images 图片列表
 */
- (void)srAlbumPickerController:(SRAlbumViewController *)picker didFinishPickingImages:(NSArray *)images {
    NSLog(@"images = %@",images);
    for (UIImage *image in images) {
        NSString *path = [LLJ_image_Path stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu.png",(unsigned long)[LLJHelper getFilesWithPath:LLJ_image_Path].count]];
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:path atomically:YES];
    }
}

@end
