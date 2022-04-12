//
//  LLJTabBarController.m
//  Dandelion
//
//  Created by 刘帅 on 2019/7/17.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import "LLJTabBarController.h"
#import "LLJTabBar.h"
#import "LLJNaviController.h"
#import "LLJMainViewController.h"
#import "LLJPersonalController.h"

@interface LLJTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) NSMutableArray *subControllers;
@property (nonatomic) NSTimeInterval lastTime;

@end

@implementation LLJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)createUI{
    
    // 设置自定义的tabbar
    [self setCustomtabbar];
    //tabbar基础属性设置
    [self setUpTabbarBaseItem];
    //创建tabbarItem
    [self createTabBarItem];
}

- (void)setUpTabbarBaseItem {
    //tabbar去除黑线
    if (@available(iOS 13.0, *)) {
        //不要设置字体否则文字显示不全
        UITabBarItemAppearance *itemAppearance = [[UITabBarItemAppearance alloc] init];
        itemAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName:LLJPurpleColor,NSFontAttributeName:LLJFont(10)};
        itemAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName:LLJColor(105, 97, 127, 1.0),NSFontAttributeName:LLJFont(10)};
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc]init];
        appearance.stackedLayoutAppearance = itemAppearance;
        appearance.shadowImage = [UIImage new];
        appearance.shadowColor = [UIColor clearColor];
        appearance.backgroundImage = [LLJHelper imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(SCREEN_WIDTH, LLJTabBarHeight)];
        self.tabBar.standardAppearance = appearance;
        if (@available(iOS 15.0, *)) {
            self.tabBar.scrollEdgeAppearance = appearance;
        }

    } else {
        //tabbar不透明
        [self.tabBar setShadowImage:[LLJHelper imageWithRenderColor:[UIColor clearColor] renderSize:CGSizeMake(SCREEN_WIDTH, 1)]];
        [self.tabBar setBackgroundImage:[LLJHelper imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(SCREEN_WIDTH, LLJTabBarHeight)]];
    }
}

- (void)createTabBarItem{
    
    LLJMainViewController *hvc = [[LLJMainViewController alloc] init];
    [self addChildController:hvc title:@"首页" titleColor:nil titleFont:nil backColor:nil backImage:nil imageName:@"shouye_unSelect" selectedImageName:@"shouye_select"];
    
    LLJPersonalController *fvc = [[LLJPersonalController alloc] init];
    [self addChildController:fvc title:@"Knowledge" titleColor:nil titleFont:nil backColor:nil backImage:nil imageName:@"wode_unselect" selectedImageName:@"wode_select"];
    
    //使用此方法可以动态添加或移除子控制器
    self.viewControllers = self.subControllers;
}

#pragma mark - 创建tabBarItem和navi -
- (void)addChildController:(UIViewController*)childController title:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont backColor:(UIColor *)backColor backImage:(UIImage *)backImage imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName
{
    //不设置iponex 系列手机 push返回后 tabbar字体变回蓝色
    self.tabBar.tintColor = LLJPurpleColor;
    
    childController.title = title;
    //为选中图片
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //选中图片
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //选中tabbar文字颜色
    [childController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName:LLJPurpleColor}forState:UIControlStateSelected];
    //为选中颜色
    [childController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:LLJColor(105, 97, 127, 1.0)}forState:UIControlStateNormal];
    //修改文字位置
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -3)];

    
    LLJNaviController* nav = [[LLJNaviController alloc] initWithRootViewController:childController];
    //[nav setUpTitleColor:titleColor font:titleFont];
    //[nav setNavigationBarHidden:YES animated:YES];
    if (backImage) {
        [nav setUpBackGroundImage:backImage];
    }else{
        [nav setUpBackGroundColor:backColor];
    }
    [self.subControllers addObject:nav];
    //[self addChildViewController:nav];
}

#pragma mark - 创建自定义 -
- (void)setCustomtabbar{
    
    LLJTabBar *tabbar = [[LLJTabBar alloc]initWithFrame:CGRectMake(0, 0, 63, SCREEN_WIDTH)];
    [self setValue:tabbar forKeyPath:@"tabBar"];
    [tabbar.plusItem addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.delegate = self;
}
#pragma mark - 录制按钮事件 -
- (void)centerBtnClick:(UIButton *)btn{
    
    if (!btn.hidden) {
        NSDictionary *dic = @{@"type":@"text",@"obj":@"中间按钮相应事件"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"centerBtnClick" object:dic];
    }
}

#pragma mark - 移除子控制器 -
- (void)removeChildController:(UIViewController *)childController{
    //动态添加移除子控制器必须使用self.viewControllers = array;的方法
    //[self addChildViewController:nav];此方法无效
    NSArray *subControllers = self.subControllers;
    for (UIViewController *subController in subControllers) {
        if ([subController isKindOfClass:[childController class]]) {
            [self.subControllers removeObject:childController];
        }
    }
    self.viewControllers = self.subControllers;
}
#pragma mark - 添加子控制器 -
- (void)addChildController:(UIViewController *)childController{
    [self insertChildController:childController atIndex:self.subControllers.count];
}
#pragma mark - 插入子控制器 -
- (void)insertChildController:(UIViewController *)childController atIndex:(NSInteger)index{
    [self.subControllers insertObject:childController atIndex:index];
    self.viewControllers = self.subControllers;
}

#pragma mark - UITabBarControllerDelegate -
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    if(tabBarController.selectedIndex == 0){
        //双击tabbar返回顶部
        NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
        if (nowTime - self.lastTime < 0.5) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollToTop" object:nil];
        }else{
            self.lastTime = nowTime;
        }
    }
}


#pragma mark - 懒加载 -
- (NSMutableArray *)subControllers {
    if (!_subControllers) {
        _subControllers = [NSMutableArray array];
    }
    return _subControllers;
}

@end
