//
//  BPAudioRecorderViewController.m
//  BWPensionPro
////
//  BPAudioRecorderViewController.m
//  BWPensionPro
//
//  Created by 刘帅 on 2019/4/22.
//  Copyright © 2019 Beiwaionline. All rights reserved.
//

#import "BPAudioRecorderViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PAMZTimerLabel.h"
#import "SRHelper.h"
#import "PFAudio.h"

@interface BPAudioRecorderViewController ()<AVAudioPlayerDelegate,MZTimerLabelDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UIImageView *preRecordImage;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *startRecordButton;

@property (weak, nonatomic) IBOutlet UIButton *disMissButton;

@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;

@property (weak, nonatomic) IBOutlet UIButton *audioPlayButton;

@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;

@property (weak, nonatomic) IBOutlet UILabel *recordLabel;

//@property (nonatomic, strong) SJVideoPlayer       *player;

@property (nonatomic, strong) AVAudioRecorder               *audioRecorder;       //音频录制
@property (nonatomic, strong) AVAudioPlayer                 *AudioPlayer;         //音频播放
@property (nonatomic, strong) AVAudioSession                *session;
@property (nonatomic, strong) PAMZTimerLabel                *audioTimeLabel;       //定时器
@property (nonatomic, copy) NSString                        *audioPath;            //音频地址
@property (nonatomic, copy) NSString                        *mp3Path;              //音频地址


@end

@implementation BPAudioRecorderViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layOutSubView];
    [self createRecord];
    
}
#pragma mark - UI -
- (void)layOutSubView{
    
    [self.view sendSubviewToBack:self.bgImageView];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(LLJD_Y(36));
    }];
    
    [self.preRecordImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(LLJD_Y(212));
        make.width.mas_equalTo(LLJD_X(218));
        make.height.mas_equalTo(2);
    }];
    
    [self.gifImageView sd_setImageWithURL:[[NSBundle mainBundle] URLForResource:@"luyin02" withExtension:@"gif"]];
    [self.gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(LLJD_Y(228));
        make.width.mas_equalTo(LLJD_X(227));
        make.height.mas_equalTo(70);
    }];
    
    [self.startRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(LLJD_Y(-42));
        make.width.mas_equalTo(LLJD_X(67));
        make.height.mas_equalTo(LLJD_X(67));
    }];
    
    [self.disMissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.startRecordButton.mas_centerY);
        make.left.mas_equalTo(self.view.mas_left).offset(LLJD_Y(67));
        make.width.mas_equalTo(LLJD_X(21));
        make.height.mas_equalTo(LLJD_Y(12));
    }];
    
    [self.recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.startRecordButton.mas_centerX);
        make.bottom.mas_equalTo(self.startRecordButton.mas_top).offset(LLJD_Y(-18));
    }];
    
    [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.startRecordButton.mas_centerY);
        make.right.mas_equalTo(self.view.mas_right).offset(LLJD_Y(-50));
        make.width.mas_equalTo(LLJD_X(60));
        make.height.mas_equalTo(LLJD_X(60));
    }];
    
    [self.audioPlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.preRecordImage.mas_bottom).offset(LLJD_Y(50));
        make.width.mas_equalTo(LLJD_X(39));
        make.height.mas_equalTo(LLJD_Y(43));
    }];
    
    self.audioTimeLabel = [[PAMZTimerLabel alloc]initWithLabel:self.timeLabel andTimerType:MZTimerLabelTypeStopWatch];
    self.audioTimeLabel.delegate = self;
    self.audioPlayButton.hidden = YES;
    self.nextStepButton.hidden = YES;
    self.gifImageView.hidden = YES;
}
#pragma mark - 创建录制工具 -
- (void)createRecord{
    
    // 真机环境下需要的代码
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
    // 0.1 创建录音文件存放路径
    self.audioPath = [self getAudioSaveFilePathString:@".caf"];
    NSURL *url = [NSURL URLWithString:self.audioPath];
    // 0.2 创建录音设置
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    // 设置编码格式
    [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    // 采样率
    [recordSettings setValue :[NSNumber numberWithFloat:8000.0] forKey: AVSampleRateKey];
    // 通道数
    [recordSettings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    //音频质量,采样质量
    [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
    // 1. 创建录音对象
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:nil];
}
- (IBAction)buttonClick:(UIButton *)sender {
    
    if (sender.tag == 10001) {
        if (!sender.selected) {
            NSLog(@"开始录音");
            if (!self.audioRecorder.isRecording) {
                
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
                // 2. 准备录音(系统会分配一些录音资源)
                [self.audioRecorder prepareToRecord];
                BOOL start = [self.audioRecorder record]; // 直接录音, 需要手动停止
                if (start) {
                    //定时器
                    self.audioTimeLabel.timerType = MZTimerLabelTypeStopWatch;
                    [self.audioTimeLabel reset];
                    [self.audioTimeLabel start];
                    self.audioPlayButton.hidden = YES;
                    self.preRecordImage.hidden = YES;
                    self.gifImageView.hidden = NO;
                    self.nextStepButton.hidden = YES;
                    self.recordLabel.hidden = YES;
                    [self.startRecordButton setImage:[UIImage imageNamed:@"video_pai02"] forState:UIControlStateNormal];
                    [self.audioPlayButton setImage:[UIImage imageNamed:@"luyin_play"] forState:UIControlStateNormal];
                    //重新初始化播放器
                    [self.AudioPlayer stop];
                    self.AudioPlayer = nil;
                    self.mp3Path = [self getAudioSaveFilePathString:@"mp3"];
                    NSLog(@"开始成功");
                }else{
                    NSLog(@"开始录音失败");
                }
            }
        }else{
            NSLog(@"停止录音");
            if (self.audioRecorder.isRecording) {
                
                [self.audioRecorder stop];
                self.nextStepButton.hidden = NO;
                self.audioPlayButton.hidden = NO;
                self.preRecordImage.hidden = NO;
                self.gifImageView.hidden = YES;
                self.preRecordImage.image = [UIImage imageNamed:@"luyin_01"];
                [self.startRecordButton setImage:[UIImage imageNamed:@"video_pai01"] forState:UIControlStateNormal];
                
                [self.audioTimeLabel pause];
                
                //音频转码
                BOOL R = [PFAudio pcm2Mp3:self.audioPath toPath:self.mp3Path isDeleteSourchFile:NO];
                if (R) {
                    NSLog(@"转码成功");
                }
            }
        }
        sender.selected = !sender.selected;
    }else if (sender.tag == 10003){
        [self.audioRecorder stop];
        [self.AudioPlayer stop];
        [self.audioTimeLabel pause];
        [SRHelper deleteFileByPath:[NSURL URLWithString:self.audioPath]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (sender.tag == 10002){
        NSLog(@"下一步");
        
        NSDictionary *dic = @{@"type":@"audio",
                              @"obj" :@[self.mp3Path]
                              };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"readyUpload" object:dic];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        if (!sender.selected) {
            NSLog(@"播放");
            // 真机环境下需要的代码
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            //准备播放
            [self.AudioPlayer play];
            self.preRecordImage.hidden = YES;
            self.gifImageView.hidden = NO;
            [self.audioPlayButton setImage:[UIImage imageNamed:@"luyin_stop"] forState:UIControlStateNormal];
            //定时器
            [self.audioTimeLabel reset];
            [self.audioTimeLabel start];
        }else{
            self.preRecordImage.hidden = NO;
            self.gifImageView.hidden = YES;
            [self.AudioPlayer stop];
            [self.audioPlayButton setImage:[UIImage imageNamed:@"luyin_play"] forState:UIControlStateNormal];
            [self.audioTimeLabel reset];
            [self.audioTimeLabel pause];
        }
        sender.selected = !sender.selected;
    }
}
//播放录音代理
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    [self.audioPlayButton setImage:[UIImage imageNamed:@"luyin_play"] forState:UIControlStateNormal];
    self.audioPlayButton.selected = NO;
    self.preRecordImage.hidden = NO;
    self.gifImageView.hidden = YES;
    [self.audioTimeLabel reset];
    [self.audioTimeLabel pause];
}
//计时器代理
-(void)timerLabel:(PAMZTimerLabel*)timerlabel countingTo:(NSTimeInterval)time timertype:(MZTimerLabelType)timerType{
    if (self.audioRecorder.isRecording) {
        //限制录音时长15分钟
        if (time >= 900.0) {
            [self.audioRecorder stop];
            self.nextStepButton.hidden = NO;
            self.audioPlayButton.hidden = NO;
            self.preRecordImage.hidden = NO;
            self.gifImageView.hidden = YES;
            self.preRecordImage.image = [UIImage imageNamed:@"luyin_01"];
            [self.startRecordButton setImage:[UIImage imageNamed:@"video_pai01"] forState:UIControlStateNormal];
            self.startRecordButton.selected = NO;
            [self.audioTimeLabel pause];
            
            //pcm转mp3
            BOOL R = [PFAudio pcm2Mp3:self.audioPath toPath:[self getAudioSaveFilePathString:@"mp3"] isDeleteSourchFile:NO];
            if (R) {
                NSLog(@"转码成功");
            }
        }
    }
}

/**
 TODO:文件路径获取
 
 @return 文件路径
 */
- (NSString *)getAudioSaveFilePathString:(NSString *)subString{
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[LLJ_Base_Path stringByAppendingPathComponent:@"RecordSourceAudio"]]) {
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:[LLJ_Base_Path stringByAppendingPathComponent:@"RecordSourceAudio"]] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HHmmss"];
    NSDate * NowDate = [NSDate dateWithTimeIntervalSince1970:now];
    NSString *timeStr = [formatter stringFromDate:NowDate];
    NSString *fileName = [NSString stringWithFormat:@"audio_%@.%@",timeStr,subString];
    NSString *filePath = [[LLJ_Base_Path stringByAppendingPathComponent:@"RecordSourceAudio"] stringByAppendingPathComponent:fileName];
    return filePath;
}
#pragma mark - 懒加载 -
- (AVAudioPlayer *)AudioPlayer{
    
    if (!_AudioPlayer && IS_VALID_STRING(self.mp3Path)) {
        
        //初始化播放器对象
        _AudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:self.mp3Path] error:nil];
        //设置声音的大小
        _AudioPlayer.volume = 1;//范围为（0到1）；
        //设置循环次数，如果为负数，就是无限循环
        //_AudioPlayer.numberOfLoops =-1;
        //设置播放进度
        _AudioPlayer.currentTime = 0;
        _AudioPlayer.delegate = self;
        [_AudioPlayer prepareToPlay];

    }
    return _AudioPlayer;
}

- (void)dealloc{
    NSLog(@"vc = %@",[self class]);
}

@end

