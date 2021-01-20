//
//  LLJDataSaveViewController.m
//  Dandelion
//
//  Created by 刘帅 on 2019/11/11.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import "LLJDataSaveViewController.h"

//model
#import "LLJCommenModel+CoreDataClass.h"

@interface LLJDataSaveViewController ()

@property (nonatomic) NSInteger addIndex;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *btn1;
@property(nonatomic,strong)NSBundle * bundle;
@property BOOL dianji;

@end

@implementation LLJDataSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createUI];
}
#pragma mark - coreData增加数据 -
- (void)addData{
    
    LLJCommenModel *model = [LLJCDHelper createModel:@"LLJCommenModel"];
    model.name = @"赞歌zzz";
    model.age = [NSString stringWithFormat:@"%ld",(long)_addIndex];
    model.imagePath = @"http://www.baidu.com";

    BOOL r =  [LLJCDHelper insertAndUpdateResource];
    if (r) {
        NSLog(@"插入数据成功");
        _addIndex ++;
    }
}

#pragma mark - coreData 查找数据 -
- (void)getData{
    
    NSArray *arr = [LLJCDHelper getResourceWithEntityName:@"LLJCommenModel" predicate:@"name = '赞歌zzz'"];
    
    for (LLJCommenModel *model in arr) {
        NSLog(@"name = %@,age = %@, image = %@",model.name,model.age,model.imagePath);
    }
}

#pragma mark - coreData 删除数据 -
- (void)deletData{
    
    BOOL r = [LLJCDHelper deleteResourceWithEntityName:@"LLJCommenModel" predicate:@"name = '赞歌zzz'"];
    if (r) {
        NSLog(@"删除成功");
    }
}

#pragma mark - coreData修改数据 -
- (void)updateData{
    
    NSArray *arr = [LLJCDHelper getResourceWithEntityName:@"LLJCommenModel" predicate:@"age = 22 AND name = '赞歌zzz'"];
    
    for (LLJCommenModel *model in arr) {
        model.age = @"250";
    }
    
    [LLJCDHelper insertAndUpdateResource];
}

#pragma mark - 本地txt写入数据 -
- (void)writeToFile{
    
    //存储路径
    NSDictionary *dic = @{@"key":@"value",@"渣渣渣":@"250"};
    NSDictionary *dic1 = @{@"key1":@"value1",@"渣渣渣1":@"260"};
    NSArray *array = @[dic,dic1];
    NSString *pptPath = [LLJ_Base_Path stringByAppendingPathComponent:@"LLJCeshi.txt"];
    //数组或字典生成字符串
    NSString *jsonStringPPT = [LLJHelper dictionaryToJson:array];
    BOOL PPTIsWrite = [jsonStringPPT writeToFile:pptPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (PPTIsWrite) {
        NSLog(@"成功写入");
    }
}

#pragma mark - 本地txt获取数据 -
- (void)getLocalFile{
    
    NSString *pptString = [NSString stringWithContentsOfFile:[LLJ_Base_Path stringByAppendingPathComponent:@"LLJCeshi.txt"] encoding:NSUTF8StringEncoding error:nil];
    //字符串生成数组或字典
    NSArray *pptArr = [LLJHelper getSetWithJsonString:pptString];
    NSLog(@"result = %@,%@",pptArr[0],pptArr[1]);
}

#pragma mark - 按钮事件 -
- (void)buttonClick:(UIButton *)sender{
    
    switch (sender.tag) {
        case 1001:
            [self addData];
            break;
        case 1002:
            [self getData];
            break;
        case 1003:
            [self deletData];
            break;
        case 1004:
            [self updateData];
            break;
        case 1005:
            [self writeToFile];
            break;
        case 1006:
            [self getLocalFile];
            break;
            
        default:
            break;
    }
}

#pragma mark - UI -
- (void)createUI{
    
    _addIndex = 0;
    
    UIButton *buttonAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonAdd setTitle:@"添加数据" forState:UIControlStateNormal];
    [buttonAdd setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    buttonAdd.tag = 1001;
    [buttonAdd addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonAdd];
    [buttonAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_centerX).offset(LLJD_X(-40));
        make.top.mas_equalTo(self.view.mas_top).offset(LLJD_X(50));
        make.width.mas_equalTo(LLJD_X(80));
        make.height.mas_equalTo(LLJD_Y(20));
    }];
    self.btn = buttonAdd;
    
    UIButton *buttonGet = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonGet setTitle:@"获取数据" forState:UIControlStateNormal];
    [buttonGet setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    buttonGet.tag = 1002;
    [buttonGet addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonGet];
    [buttonGet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_centerX).offset(LLJD_X(40));
        make.top.mas_equalTo(self.view.mas_top).offset(LLJD_X(50));
        make.width.mas_equalTo(LLJD_X(80));
        make.height.mas_equalTo(LLJD_Y(20));
    }];
    self.btn1 = buttonGet;
    
    UIButton *buttonDelet = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonDelet setTitle:@"删除数据" forState:UIControlStateNormal];
    [buttonDelet setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    buttonDelet.tag = 1003;
    [buttonDelet addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonDelet];
    [buttonDelet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_centerX).offset(LLJD_X(-40));
        make.top.mas_equalTo(buttonAdd.mas_bottom).offset(LLJD_X(50));
        make.width.mas_equalTo(LLJD_X(80));
        make.height.mas_equalTo(LLJD_Y(20));
    }];
    
    UIButton *buttonUpdate = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonUpdate setTitle:@"修改数据" forState:UIControlStateNormal];
    [buttonUpdate setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    buttonUpdate.tag = 1004;
    [buttonUpdate addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonUpdate];
    [buttonUpdate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_centerX).offset(LLJD_X(40));
        make.top.mas_equalTo(buttonGet.mas_bottom).offset(LLJD_X(50));
        make.width.mas_equalTo(LLJD_X(80));
        make.height.mas_equalTo(LLJD_Y(20));
    }];
    
    UIButton *buttonWriteToFile = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonWriteToFile setTitle:@"写入txt文件" forState:UIControlStateNormal];
    [buttonWriteToFile setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    buttonWriteToFile.tag = 1005;
    [buttonWriteToFile addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonWriteToFile];
    [buttonWriteToFile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_centerX).offset(LLJD_X(-40));
        make.top.mas_equalTo(buttonDelet.mas_bottom).offset(LLJD_X(50));
        make.width.mas_equalTo(LLJD_X(120));
        make.height.mas_equalTo(LLJD_Y(20));
    }];
    
    UIButton *getButtonWriteToFile = [UIButton buttonWithType:UIButtonTypeCustom];
    [getButtonWriteToFile setTitle:@"获取txt文件" forState:UIControlStateNormal];
    [getButtonWriteToFile setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    getButtonWriteToFile.tag = 1006;
    [getButtonWriteToFile addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getButtonWriteToFile];
    [getButtonWriteToFile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_centerX).offset(LLJD_X(40));
        make.top.mas_equalTo(buttonUpdate.mas_bottom).offset(LLJD_X(50));
        make.width.mas_equalTo(LLJD_X(120));
        make.height.mas_equalTo(LLJD_Y(20));
    }];
}

@end
