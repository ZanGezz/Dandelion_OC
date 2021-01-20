//
//  FWGpwView.m
//  SpringsCapital
//
//  Created by 刘帅 on 2020/4/22.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import "FWGpwView.h"
#import "FWGpwButton.h"
#import "FWGpwModel.h"

@interface FWGpwView()

@property (nonatomic, strong)FWGpwModel *model;             //数据模型
@property (nonatomic, assign)CGPoint currentPoint;          //当前处于哪个按钮范围内
@property (nonatomic, assign)GesturePasswordStatus status;  //当前控件器所处状态(设置、重新设置、登录)
@property (nonatomic, assign)NSInteger inputNum;            //输入的次数
@property (nonatomic, assign)NSInteger resetInputNum;       //重置密码时验证旧密码 输入的次数
@property (nonatomic, strong)NSString *firstPassword;       //表示设置密码时 第一次输入的手势密码
@property (nonatomic, copy)NSString *remainCount;          //输入错误次数

@end

@implementation FWGpwView

#pragma mark - init -
+(instancetype)model:(FWGpwModel *)model status:(GesturePasswordStatus)status frame:(CGRect)frame onGetCorrectPswd:(void (^)(NSString *password))GetCorrectPswd onGetIncorrectPswd:(void (^)(NSString *errorCount))GetIncorrectPswd errorInput:(void (^)(void))errorInput
{
    return [self model:model status:status frame:frame onPasswordSet:nil onGetCorrectPswd:GetCorrectPswd onGetIncorrectPswd:GetIncorrectPswd errorInput:errorInput];
}

+(instancetype)model:(FWGpwModel *)model status:(GesturePasswordStatus)status frame:(CGRect)frame  onPasswordSet:(void (^)(void))onPasswordSet onGetCorrectPswd:(void (^)(NSString *password))GetCorrectPswd onGetIncorrectPswd:(void (^)(NSString *errorCount))GetIncorrectPswd errorInput:(void (^)(void))errorInput
{
    return [self model:model status:status frame:frame verificationPassword:nil verificationError:nil onPasswordSet:onPasswordSet onGetCorrectPswd:GetCorrectPswd onGetIncorrectPswd:GetIncorrectPswd errorInput:errorInput];
}

+(instancetype)model:(FWGpwModel *)model status:(GesturePasswordStatus)status frame:(CGRect)frame verificationPassword:(void (^)(void))verificationPassword verificationError:(void (^)(void))verificationError onPasswordSet:(void (^)(void))onPasswordSet onGetCorrectPswd:(void (^)(NSString *password))GetCorrectPswd onGetIncorrectPswd:(void (^)(NSString *errorCount))GetIncorrectPswd errorInput:(void (^)(void))errorInput
{
    FWGpwView *gesView = [[FWGpwView alloc] initWithFrame:frame model:model];
    gesView.status = status;
    gesView.verificationPassword = verificationPassword;
    gesView.verificationError = verificationError;
    gesView.onPasswordSet = onPasswordSet;
    gesView.onGetCorrectPswd = GetCorrectPswd;
    gesView.onGetIncorrectPswd = GetIncorrectPswd;
    gesView.errorInput = errorInput;
    return gesView;
}

- (instancetype)initWithFrame:(CGRect)frame model:(FWGpwModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.model = model;
        
        self.selectorAry = [[NSMutableArray alloc] init];
        [self setPropertiesByState:GesturePasswordButtonStateNormal];
        NSInteger size = model.circleRadius * 2 + 2;
        NSInteger margin = LLJD_Y(36);
        float ins = LLJD_X(46);
        for (int i = 0; i < 9; i++) {
            NSInteger row = i/3;
            NSInteger col = i%3;
            FWGpwButton *gesturePasswordButton = [[FWGpwButton alloc] initWithFrame:CGRectMake(ins+col*size+col*margin, row*size+row*margin, size, size) model:model];
            gesturePasswordButton.buttonNum = i;
            [gesturePasswordButton setTag:i+1];
            [self addSubview:gesturePasswordButton];
        }
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if ([self.selectorAry count] == 0) {
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:self.model.lineWidth];
    [self.lineColor set];
    [path setLineJoinStyle:kCGLineJoinRound];// 设置头尾相接处的样式
    [path setLineCapStyle:kCGLineCapRound];// 设置头尾的样式
    for (NSInteger i = 0; i < self.selectorAry.count; i ++) {
        FWGpwButton *btn = self.selectorAry[i];
        if (i == 0) {
            [path moveToPoint:[btn center]];
        }else{
            [path addLineToPoint:[btn center]];
        }
        [btn setNeedsDisplay];
    }
    [path addLineToPoint:self.currentPoint];
    [path stroke];
}

- (void)setNeedsDisplayWithArray:(NSArray *)buttonArray{

    for (FWGpwButton *button1 in buttonArray) {
        for (FWGpwButton *button in self.subviews) {
            if ([button isKindOfClass:[FWGpwButton class]]){
                if (button1.buttonNum == button.buttonNum) {
                    [self.selectorAry addObject:button];
                }
            }
        }
    }
    [self setNeedsDisplay];
}

#pragma mark - touchAction -
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.currentPoint = point;
    for (FWGpwButton *btn in self.subviews) {
        if ([btn isKindOfClass:[FWGpwButton class]]) {
            if (CGRectContainsPoint(btn.frame, point)) {
                [btn setSelected:YES];
                if (![self.selectorAry containsObject:btn]) {
                    [self.selectorAry addObject:btn];
                    [self setPropertiesByState:GesturePasswordButtonStateSelected];
                }
            }
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.currentPoint = point;
    for (FWGpwButton *btn in self.subviews) {
        if ([btn isKindOfClass:[FWGpwButton class]]) {
            if (CGRectContainsPoint(btn.frame, point)) {
                [btn setSelected:YES];
                if (![self.selectorAry containsObject:btn]) {
                    [self.selectorAry addObject:btn];
                    [self setPropertiesByState:GesturePasswordButtonStateSelected];
                }
            }
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (self.status == GesturePasswordStatusSet || self.selectorAry.count < 4) {
        [self checkGesturePassword:YES];
    }else{
        [self checkGesPassWordReq];
    }
}

#pragma mark - 验证手势密码 -
- (void)checkGesPassWordReq{
    
    if ([[self getGesturePassword] isEqualToString:@"12369"]) {
        [self checkGesturePassword:YES];
    }else{
        [self checkGesturePassword:NO];
    }
}

#pragma mark - 获取输入的密码 -
- (NSString *)getGesturePassword{
    NSString *inputPassword = @"";
    for (FWGpwButton *btn in self.selectorAry) {
        inputPassword = [inputPassword stringByAppendingFormat:@"%@",@(btn.tag)];
    }
    return inputPassword;
}

#pragma mark - 检验密码是否正确 -
- (void)checkGesturePassword:(BOOL)sucess{
    
    if (self.selectorAry.count < 4) {
        !self.errorInput ?: self.errorInput();
        [self setPropertiesByState:GesturePasswordButtonStateNormal];
    }else if (self.status == GesturePasswordStatusSet) {
        [self setPasswordBlock];
    }else if(self.status == GesturePasswordStatusReset){
    
        if (sucess) {
            !self.verificationPassword ?: self.verificationPassword();
            self.status = GesturePasswordStatusSet;
            [self performSelector:@selector(lockState:) withObject:[NSArray arrayWithObject:[NSNumber numberWithInteger:GesturePasswordButtonStateNormal]] afterDelay:0.3f];
        }else{
            !self.verificationError ?: self.verificationError();
            [self setPropertiesByState:GesturePasswordButtonStateIncorrect];
        }
        
    }else if(self.status == GesturePasswordStatusLogin){
        if (sucess) {
            !self.onGetCorrectPswd ?: self.onGetCorrectPswd([self getGesturePassword]);
            [self setPropertiesByState:GesturePasswordButtonStateNormal];
        }else{
            !self.onGetIncorrectPswd ?: self.onGetIncorrectPswd(self.remainCount);
            [self setPropertiesByState:GesturePasswordButtonStateIncorrect];
        }
    }
    FWGpwButton *btn = [self.selectorAry lastObject];
    [self setCurrentPoint:btn.center];
    [self setNeedsDisplay];
}

#pragma mark - Logic -
- (void)setPasswordBlock
{
    if (self.inputNum == 0) {
        self.firstPassword = [self getGesturePassword];
        !self.onPasswordSet ?: self.onPasswordSet();
        self.inputNum += 1;
        [self performSelector:@selector(lockState:) withObject:[NSArray arrayWithObject:[NSNumber numberWithInteger:GesturePasswordButtonStateNormal]] afterDelay:0.3f];
    }else{
        NSString *secondPassword = [self getGesturePassword];
        if ([self.firstPassword isEqualToString:secondPassword]) {
            !self.onGetCorrectPswd ?: self.onGetCorrectPswd([self getGesturePassword]);
            [self performSelector:@selector(lockState:) withObject:[NSArray arrayWithObject:[NSNumber numberWithInteger:GesturePasswordButtonStateNormal]] afterDelay:0.3f];
        }else{
            !self.onGetIncorrectPswd ?: self.onGetIncorrectPswd(self.remainCount);
            [self setPropertiesByState:GesturePasswordButtonStateIncorrect];
            self.inputNum -= 1;
        }
    }
}

- (void)setPropertiesByState:(GesturePasswordButtonState)buttonState{
    switch (buttonState) {
        case GesturePasswordButtonStateNormal:
            [self setUserInteractionEnabled:YES];
            [self resetButtons];
            self.lineColor = self.model.lineColorNormal;
            self.fillColor = self.model.fillColorNormal;
            self.strokeColor = self.model.strokeColorNormal;
            self.centerPointColor = self.model.centerPointColorNormal;
            break;
        case GesturePasswordButtonStateSelected:
            self.lineColor = self.model.lineColorSelected;
            self.fillColor = self.model.fillColorSelected;
            self.strokeColor = self.model.strokeColorSelected;
            self.centerPointColor = self.model.centerPointColorSelected;
            break;
        case GesturePasswordButtonStateIncorrect:
            [self setUserInteractionEnabled:NO];
            self.lineColor = self.model.lineColorIncorrect;
            self.fillColor = self.model.fillColorIncorrect;
            self.strokeColor = self.model.strokeColorIncorrect;
            self.centerPointColor = self.model.centerPointColorIncorrect;
            [self performSelector:@selector(lockState:) withObject:[NSArray arrayWithObject:[NSNumber numberWithInteger:GesturePasswordButtonStateNormal]] afterDelay:0.5f];
            break;
        default:
            break;
    }
}

- (void)lockState:(NSArray *)states {
    NSNumber *stateNumber = [states objectAtIndex:0];
    [self setPropertiesByState:[stateNumber integerValue]];
}

- (void)resetButtons {
    for (NSInteger i=0; i<[self.selectorAry count]; i++) {
        FWGpwButton *button = self.selectorAry[i];
        [button setSelected:NO];
    }
    [self.selectorAry removeAllObjects];
    [self setNeedsDisplay];
}

- (void)reset{
    [self setPropertiesByState:GesturePasswordButtonStateIncorrect];
    self.inputNum = 0;
}

- (void)dealloc{
    NSLog(@"FWGpwView ..");
}

@end
