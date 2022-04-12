//
//  LLJLimitImagePickerController.m
//  
//
//  Created by 刘帅 on 2021/1/5.
//

#import "LLJLimitImagePickerController.h"
#import <PhotosUI/PhotosUI.h>
#import "LLJImagePickerCell.h"

@interface LLJLimitImagePickerController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *photoArray;

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *goSetting;
@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) UILabel *alertTitle;
@property (nonatomic, strong) UILabel *alertContent;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation LLJLimitImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
}

#pragma mark - 点击事件 -
- (void)buttonClick:(UIButton *)sender {
    switch (sender.tag) {
        case 30001:
        {
            //返回
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 30003:
        {
            //去系统设置
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
            break;
        case 30004:
        {
            //访问部分照片
            self.bgView.hidden = YES;
            self.titleL.text = @"可访问的照片";
            //获取选择的图片
            [self getSelectPhotosOriginal:YES];
        }
            break;
            
        default:
            break;
    }
}
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    NSLog(@"change");
    //获取选择的图片
    [self getSelectPhotosOriginal:NO];
}

- (void)getSelectPhotosOriginal:(BOOL)original {
    
    [self.photoArray removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        for (PHAssetCollection *assetCollection in assetCollections) {
            [self enumerateAssetsInAssetCollection:assetCollection original:NO];
        }
        
        PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
        [self enumerateAssetsInAssetCollection:cameraRoll original:NO];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.photoArray addObject:[UIImage imageNamed:@"icon-test"]];
            [self.collectionView reloadData];
        });
    });
}
/*  遍历相簿中的全部图片
*  @param assetCollection 相簿
*  @param original        是否要原图
*/
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
   NSLog(@"相簿名:%@", assetCollection.localizedTitle);
   PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
   options.resizeMode = PHImageRequestOptionsResizeModeFast;
   options.synchronous = YES;
   PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
   for (PHAsset *asset in assets) {
       CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeMake(SCREEN_WIDTH/4.0, SCREEN_WIDTH/4.0);
       __weak typeof(self) weakSelf = self;
       [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
           if (result) {
               original ? [weakSelf.photoArray addObject:result] : [weakSelf.photoArray addObject:result];
           }
       }];
   }
}

#pragma mark - UICollectionViewDataSource -
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(self.view.frame) / 4.0, CGRectGetWidth(self.view.frame) / 4.0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LLJImagePickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(LLJImagePickerCell.class) forIndexPath:indexPath];
    if (self.photoArray.count > indexPath.row) {
        if (self.photoArray.count - 1 == indexPath.row) {
            [cell setUpImage:self.photoArray[indexPath.row] isAddImage:YES];
        } else {
            [cell setUpImage:self.photoArray[indexPath.row] isAddImage:NO];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.photoArray.count > indexPath.row) {
        if (indexPath.row == self.photoArray.count - 1) {
            //继续选择照片
            if (@available(iOS 14, *)) {
                [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
                [[PHPhotoLibrary sharedPhotoLibrary] presentLimitedLibraryPickerFromViewController:self];
            }
        } else {
            !self.selectImage ?: self.selectImage(self.photoArray[indexPath.row]);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - UI -
- (void)setUpUI {
    
    self.view.backgroundColor = LLJColor(50, 50, 50, 1);
    
    //UI
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.titleL];
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.alertTitle];
    [self.bgView addSubview:self.alertContent];
    [self.bgView addSubview:self.goSetting];
    [self.bgView addSubview:self.selectButton];
    
    [self layoutSubView];
}

- (void)layoutSubView {
    //返回
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.top.mas_equalTo(self.view.mas_top).offset(40);
    }];
    //标题
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backButton.mas_centerY);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    //UICollectionView
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backButton.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    //bgview
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backButton.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    [self.alertTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.bgView.mas_top).offset(120);
        make.left.mas_equalTo(self.view.mas_left).offset(30);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
    }];
    [self.alertContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.alertTitle.mas_bottom).offset(30);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.right.mas_equalTo(self.view.mas_right).offset(-40);
    }];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-120);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
    }];
    [self.goSetting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.selectButton.mas_top).offset(-60);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(46);
    }];
}

#pragma mark - 懒加载属性 -
- (NSMutableArray *)photoArray {
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = self.view.backgroundColor;
        _collectionView.backgroundView.backgroundColor = self.collectionView.backgroundColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:LLJImagePickerCell.class forCellWithReuseIdentifier:NSStringFromClass(LLJImagePickerCell.class)];
    }
    return _collectionView;
}
- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont systemFontOfSize:20];
        _titleL.textColor = [UIColor whiteColor];
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    return _titleL;
}
- (UILabel *)alertContent {
    if (!_alertContent) {
        _alertContent = [[UILabel alloc]init];
        _alertContent.font = [UIFont systemFontOfSize:18];
        _alertContent.text = @"****只能访问相册中部分照片，建议前往系统设置，允许访问「照片」中的「所以照片」。";
        _alertContent.textColor = [UIColor whiteColor];
        _alertContent.textAlignment = NSTextAlignmentCenter;
        _alertContent.numberOfLines = 0;
    }
    return _alertContent;
}
- (UILabel *)alertTitle {
    if (!_alertTitle) {
        _alertTitle = [[UILabel alloc]init];
        _alertTitle.text = @"无法访问相册中的所有照片";
        _alertTitle.font = [UIFont boldSystemFontOfSize:24];
        _alertTitle.textColor = [UIColor whiteColor];
        _alertTitle.textAlignment = NSTextAlignmentCenter;
        _alertTitle.numberOfLines = 0;
    }
    return _alertTitle;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = LLJColor(50, 50, 50, 1);
    }
    return _bgView;
}
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"cha"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _backButton.tag = 30001;
    }
    return _backButton;
}

- (UIButton *)goSetting {
    if (!_goSetting) {
        _goSetting = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goSetting setTitle:@"前往系统设置" forState:UIControlStateNormal];
        _goSetting.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _goSetting.layer.masksToBounds = YES;
        _goSetting.layer.cornerRadius = 5.0;
        _goSetting.backgroundColor = LLJColor(15, 193, 96, 1);
        [_goSetting setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_goSetting addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _goSetting.tag = 30003;
    }
    return _goSetting;
}
- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setTitle:@"继续访问部分照片" forState:UIControlStateNormal];
        _selectButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_selectButton setTitleColor:LLJColor(125, 143, 167, 1) forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _selectButton.tag = 30004;
    }
    return _selectButton;
}

-(void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

@end
