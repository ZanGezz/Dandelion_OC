//
//  LLJTextFieldController.m
//  Dandelion
//
//  Created by 刘帅 on 2020/10/12.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJTextFieldController.h"
#import "LLJTextField.h"

@interface LLJTextFieldController ()<LLJTextFieldDelegate>

@property (nonatomic, strong) NSMutableString *inputString;
@property (nonatomic, strong) LLJTextField *content;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSDate *date;

@end

@implementation LLJTextFieldController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpUI];
}

- (void)setUpUI {
    
    self.date = [NSDate date];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.inputString = [NSMutableString string];
    [self.view addSubview:self.content];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"YYYY-MM-dd" forState:UIControlStateNormal];
    [button setTitleColor:LLJBlackColor forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 200, 100, 20);
    button.tag = 1000001;
    button.titleLabel.font = LLJBoldFont(14);
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:@"yyyy-MM-dd" forState:UIControlStateNormal];
    [button1 setTitleColor:LLJBlackColor forState:UIControlStateNormal];
    button1.frame = CGRectMake(250, 200, 100, 20);
    button1.tag = 1000002;
    button1.titleLabel.font = LLJBoldFont(14);
    [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"2020-10-1" forState:UIControlStateNormal];
    [button2 setTitleColor:LLJBlackColor forState:UIControlStateNormal];
    button2.frame = CGRectMake(250, 300, 100, 20);
    button2.tag = 1000003;
    button2.titleLabel.font = LLJBoldFont(14);
    [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button3 setTitle:@"今天" forState:UIControlStateNormal];
    [button3 setTitleColor:LLJBlackColor forState:UIControlStateNormal];
    button3.frame = CGRectMake(100, 300, 100, 20);
    button3.tag = 1000004;
    button3.titleLabel.font = LLJBoldFont(14);
    [button3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    
    [self.view addSubview:self.titleLabel];
}

- (void)buttonClick:(UIButton *)sender {
    
    NSString *dateString = @"******";
    if (sender.tag == 1000001) {
        dateString = [LLJHelper stringFromDate:self.date formatter:sender.titleLabel.text];
    }else if(sender.tag == 1000002){
        dateString = [LLJHelper stringFromDate:self.date formatter:sender.titleLabel.text];
    }else if(sender.tag == 1000003){
        self.date = [LLJHelper dateFromString:sender.titleLabel.text formatter:@"yyyy-MM-dd"];
    }else if(sender.tag == 1000004){
        self.date = [NSDate date];
    }
    self.titleLabel.text = dateString;
}

- (void)valueChanged:(LLJTextField *)textField {
    NSLog(@"text = %@, input = %@",textField.text,textField.inputText);
}
- (LLJTextField *)content{
    if (!_content) {
        _content = [[LLJTextField alloc]initWithFrame:CGRectMake(100, 100, 200, 40)];
        _content.clearButtonMode = UITextFieldViewModeWhileEditing;
        _content.keyboardType = UIKeyboardTypeDefault;
        _content.returnKeyType = UIReturnKeyDone;
        _content.backgroundColor = [UIColor lightGrayColor];
        _content.type = LLJInputTextTypeFullSecret;
        _content.llj_delegate = self;
    }
    return _content;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 400, SCREEN_WIDTH, 20)];
        _titleLabel.font = LLJCommenFont;
        _titleLabel.textColor = LLJCommenColor;
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
