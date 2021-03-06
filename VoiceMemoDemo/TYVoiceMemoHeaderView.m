//
//  TYVoiceMemoHeaderView.m
//  VoiceMemoDemo
//
//  Created by Maty on 2018/8/1.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import "TYVoiceMemoHeaderView.h"
#import "TYRecorderTool.h"
#import "TYMemo.h"
#import "TYLevelPairs.h"
#import "TYLevelsView.h"

#define TYSCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define TYSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface TYVoiceMemoHeaderView ()

@property (nonatomic, strong) UIButton *playAndPauseButton;
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CADisplayLink *levelTimer;
@property (nonatomic, strong) TYLevelsView *levelsView;

@end

@implementation TYVoiceMemoHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - timeTimer
- (void)startTimer {
    self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)updateTime {
    self.timeLabel.text = [TYRecorderTool shareInstance].formattedCurrentTime;
}

#pragma mark - LevelTimer
- (void)startMeterTimer {
    [self.levelTimer invalidate];
    self.levelTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeter)];
    self.levelTimer.frameInterval = 5;
    [self.levelTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopMeterTimer {
    [self.levelTimer invalidate];
    self.levelTimer = nil;
    [self.levelsView resetLevelMeter];
}

- (void)updateMeter {
    TYLevelPairs *levelPairs = [[TYRecorderTool shareInstance] levels];
    self.levelsView.level = levelPairs.linearLevel;
    self.levelsView.peakLevel = levelPairs.linearPeakLevel;
    self.levelsView.levelPairs = levelPairs;
    [self.levelsView setNeedsDisplay];
}

#pragma mark - Button Method
- (void)playAndPauseButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        // 开始录制
        [[TYRecorderTool shareInstance] record];
        
        [self startTimer];
        
        [self startMeterTimer];
        
    } else {
        NSLog(@"暂停");
        [[TYRecorderTool shareInstance] pause];
        
        [self stopTimer];
        
    }
}

- (void)stopButtonClick:(UIButton *)button {
    [[TYRecorderTool shareInstance] stopWithCompletionHandler:^(BOOL success) {
        if (success) {
            
            [self stopTimer];
            
            [self stopMeterTimer];
            
            [self.playAndPauseButton setSelected:NO];
            [self.playAndPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
           
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"存储语音备忘录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                NSLog(@"textField.text = %@",textField.text);
                
            }];
            
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVc addAction:deleteAction];
            
            UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"存储" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 取textF 的值
                UITextField *textF = alertVc.textFields.firstObject;
                NSString *voiceFileName = textF.text;
                [[TYRecorderTool shareInstance] saveRecordingWithName:voiceFileName completionHandler:^(BOOL success, TYMemo *memo) {
                    if (success) {
                        
                        NSLog(@"%@",memo);
                        NSString *voiceName = memo.name;
                        NSURL *voiceUrl = memo.url;
                        
                        NSString *voiceTime = self.timeLabel.text;
                        memo.recordVoiceTime = voiceTime;
                        
                        [self.memoInstanceMutArray addObject:memo];
                        [self.voiceNameMutArray addObject:voiceName];
                        [self.voiceUrlMutArray addObject:voiceUrl];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"TYNotification_SaveVoiceSuccess" object:nil];
                        
                    }
                }];
            }];
            [alertVc addAction:saveAction];
            
            [[self viewController] presentViewController:alertVc animated:YES completion:^{
                
            }];
            
        }
    }];
}

#pragma mark - UI
- (void)setupUI {
    self.backgroundColor = [UIColor blackColor];
    
    self.playAndPauseButton.frame = CGRectMake(TYSCREEN_WIDTH * 0.5 - 100-10, 100, 80, 80);
    [self addSubview:self.playAndPauseButton];
    
    self.stopButton.frame = CGRectMake(TYSCREEN_WIDTH * 0.5 + 100-10-60, 100, 80, 80);
    [self addSubview:self.stopButton];
    
    self.timeLabel.frame = CGRectMake(TYSCREEN_WIDTH * 0.5-100, 40, 200, 40);
    [self addSubview:self.timeLabel];
    
    self.levelsView.frame = CGRectMake(0, 200, TYSCREEN_WIDTH, 80);
    [self addSubview:self.levelsView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.frame = CGRectMake(0, 299, TYSCREEN_WIDTH, 1);
    [self addSubview:lineView];
    
}

#pragma mark - Lazy Load
- (UIButton *)playAndPauseButton {
    if (nil == _playAndPauseButton) {
        _playAndPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playAndPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_playAndPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        [_playAndPauseButton addTarget:self action:@selector(playAndPauseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playAndPauseButton;
}

- (UIButton *)stopButton {
    if (nil == _stopButton) {
        _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        [_stopButton addTarget:self action:@selector(stopButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopButton;
}

- (UILabel *)timeLabel {
    if (nil == _timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font = [UIFont systemFontOfSize:30];
        _timeLabel.text = @"00:00:00";
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (NSMutableArray *)voiceNameMutArray {
    if (nil == _voiceNameMutArray) {
        _voiceNameMutArray = [NSMutableArray array];
    }
    return _voiceNameMutArray;
}

- (NSMutableArray *)voiceUrlMutArray {
    if (nil == _voiceUrlMutArray) {
        _voiceUrlMutArray = [NSMutableArray array];
    }
    return _voiceUrlMutArray;
}

- (NSMutableArray *)memoInstanceMutArray {
    if (nil == _memoInstanceMutArray) {
        _memoInstanceMutArray = [NSMutableArray array];
    }
    return _memoInstanceMutArray;
}

- (TYLevelsView *)levelsView {
    if (nil == _levelsView) {
        _levelsView = [[TYLevelsView alloc] init];
    }
    return _levelsView;
}

#pragma mark 拿到控制器
//一直遍历视图的父视图,找他的响应者.如果响应者是视图控制器,则返回它.
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]){
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


@end
