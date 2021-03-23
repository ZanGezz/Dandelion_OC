//
//  LLJCycleView.m
//  Dandelion
//
//  Created by 刘帅 on 2021/2/24.
//  Copyright © 2021 liushuai. All rights reserved.
//

#import "LLJCycleView.h"
#import "LLJCycleModel.h"

@interface LLJCycleView()

//数据数组
@property (nonatomic, strong) NSArray<LLJCycleModel *> *sourceArray;
//画图view
@property (nonatomic) UIView *cycleView;
//画图layer
@property (nonatomic) CAShapeLayer *cycleLayer;
//nameLabel
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation LLJCycleView

#pragma mark - 初始化 -
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //初始化默认设置基础数据
        self.backgroundColor  = [UIColor whiteColor];
        self.lineWidth        = 30.0;
        self.cycleRadius      = MIN(frame.size.width, frame.size.height) / 2.0 - self.lineWidth / 2.0;
        self.cycleCenterPoint = CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0);
        self.clockwise        = YES;
        self.needDivision     = YES;
        self.divisionRatio    = 0.002;
        self.divisionColor    = [UIColor whiteColor];
        self.animationDuration = 1.0;
        self.strokeWithAnimation = NO;
        self.startAngle       = 0.0;
        self.endAngle         = M_PI * 2.0;
    }
    return self;
}

#pragma mark - 开始画图 -
- (void)strokeWithSource:(NSArray *)sourceArray {
    //获取画图数据
    if (self.needDivision) {
        self.sourceArray = [self dealWithSourceArray:[self addDevisionSource:sourceArray]];
    } else {
        self.sourceArray = [self dealWithSourceArray:sourceArray];
    }
    [self.superview layoutIfNeeded];
    //调起drawract画图
    [self setNeedsDisplay];
}

#pragma mark - 添加分割数据 -
- (NSArray *)addDevisionSource:(NSArray *)sourceArray {
    //只有一个数据时，不添加
    if (sourceArray.count == 1) {
        return sourceArray;
    }
    //有多个数据时 穿插分割数据
    NSMutableArray *array = [NSMutableArray array];
    for (LLJCycleModel *model in sourceArray) {
        LLJCycleModel *divisionModel = [[LLJCycleModel alloc]init];
        divisionModel.estimateRatio  = self.divisionRatio;
        divisionModel.strokeColor    = self.divisionColor;
        [array addObject:model];
        [array addObject:divisionModel];
    }
    return array;
}

#pragma mark - 处理数组 - 按比例画图 -
- (NSArray *)dealWithSourceArray:(NSArray *)sourceArray {
    //处理数据占比，使其最终总数为100%，误差从最大占比中扣除
    //1.找出最大占比数据
    double maxRadio = 0.0;          //最大占比
    double totalRadio = 0.0;        //总占比  此时的总占比因为计算误差原因，不一定等于1
    for (LLJCycleModel *model in sourceArray) {
        if (model.estimateRatio > maxRadio) {
            maxRadio = model.estimateRatio;
        }
        totalRadio += model.estimateRatio;
    }
    //重置最大占比
    for (LLJCycleModel *model in sourceArray) {
        if (model.estimateRatio == maxRadio) {
            model.estimateRatio = 1 - totalRadio + maxRadio;
            break;
        }
    }
    return sourceArray;
}

#pragma mark - 画图 -
- (void)drawRect:(CGRect)rect {
    LLJWeakSelf(self);
    //移除子视图
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //创建新的画图view
    _cycleView = [[UIView alloc]init];
    [self addSubview:_cycleView];
    [_cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [_cycleView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.cycleView.mas_centerX);
        make.centerY.mas_equalTo(self.cycleView.mas_centerY);
        make.width.mas_equalTo(self.cycleRadius*2 - self.lineWidth - 8);
    }];
    //添加画图layer
    _cycleLayer = [CAShapeLayer layer];
    [_cycleView.layer addSublayer:_cycleLayer];
    //遍历数组画图
    __block CGFloat startRadio = 0.0;  //从0度开始
    __block CGFloat endRadio   = 0.0;
    [self.sourceArray enumerateObjectsUsingBlock:^(LLJCycleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //设置开始角度
        endRadio = endRadio + obj.estimateRatio;
        //创建layer
        CAShapeLayer *layer = [weakSelf getShapeLayerWithStrokerColor:obj.strokeColor startRadio:startRadio endRadio:endRadio];
        [_cycleLayer addSublayer:layer];
        //设置结束角度
        startRadio = endRadio;
    }];
    
    //是否开启动画
    if (self.strokeWithAnimation) {
        [self drawWithAnimation];
    }
}
//获取layer
- (CAShapeLayer *)getShapeLayerWithStrokerColor:(UIColor *)strokeColor startRadio:(CGFloat)startRadio endRadio:(CGFloat)endRadio {
    //创建贝塞尔曲线 M_PI
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.cycleCenterPoint radius:self.cycleRadius startAngle:self.startAngle endAngle:self.endAngle clockwise:self.clockwise];
    //创建layer
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = strokeColor.CGColor;
    layer.fillColor   = [UIColor clearColor].CGColor;
    layer.strokeStart = startRadio;   //[0 1]   贝塞尔曲线是[0 M_PI*2]
    layer.strokeEnd   = endRadio;     //[0 1]   贝塞尔曲线是[0 M_PI*2]
    layer.lineWidth   = self.lineWidth;
    layer.path        = path.CGPath;
    
    return layer;
}
//画图动画
- (void)drawWithAnimation {
    
    CAShapeLayer *maskLayer = [self getShapeLayerWithStrokerColor:[UIColor blackColor] startRadio:0 endRadio:1];
    self.cycleLayer.mask = maskLayer;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration  = self.animationDuration;
    animation.fromValue = @0;
    animation.toValue   = @1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    [maskLayer addAnimation:animation forKey:@"circleAnimation"];
}

- (void)setText:(NSString *)text {
    _text = text;
    _nameLabel.text = text;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor lightGrayColor];
        _nameLabel.font = LLJFont(14);
        _nameLabel.numberOfLines = 0;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.text = @"资产分布分布分布";
    }
    return _nameLabel;
}
@end
