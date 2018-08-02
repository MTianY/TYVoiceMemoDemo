//
//  TYRecorderTool.m
//  VoiceMemoDemo
//
//  Created by Maty on 2018/8/1.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import "TYRecorderTool.h"
#import <AVFoundation/AVFoundation.h>
#import "TYMemo.h"

static TYRecorderTool *_instance = nil;

@interface TYRecorderTool () <
AVAudioRecorderDelegate
>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) TYRecordingStopCompletionHandler stopCompletionHander;

@end

@implementation TYRecorderTool

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        
        NSString *tmpDir = NSTemporaryDirectory();
        NSString *filePath = [tmpDir stringByAppendingPathComponent:@"memo.caf"];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        
        NSDictionary *settings = @{
                                   AVFormatIDKey : @(kAudioFormatAppleIMA4),
                                   AVSampleRateKey : @44100.0f,
                                   AVNumberOfChannelsKey : @1,
                                   AVEncoderBitDepthHintKey : @16,
                                   AVEncoderAudioQualityKey : @(AVAudioQualityMedium)
                                   };
        
        NSError *error;
        self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:fileURL settings:settings error:&error];
        
        if (self.audioRecorder) {
            self.audioRecorder.delegate = self;
            [self.audioRecorder prepareToRecord];
        } else {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
        
    }
    return self;
}

#pragma mark - Custom Method
- (BOOL)record {
    return [self.audioRecorder record];
}

- (void)pause {
    [self.audioRecorder pause];
}

- (void)stopWithCompletionHandler:(TYRecordingStopCompletionHandler)handler {
    self.stopCompletionHander = handler;
    [self.audioRecorder stop];
}

- (void)saveRecordingWithName:(NSString *)name completionHandler:(TYRecordingSaveCompletionHandler)handler {
    NSTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate];
    NSString *filename = [NSString stringWithFormat:@"%@-%f.caf", name, timestamp];
    NSString *docsDir = [self documentsDirectory];
    NSString *destPath = [docsDir stringByAppendingPathComponent:filename];
    NSURL *srcURL = self.audioRecorder.url;
    NSURL *destURL = [NSURL fileURLWithPath:destPath];
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] copyItemAtURL:srcURL toURL:destURL error:&error];
    
    if (success) {
        handler(YES, [TYMemo memoWithTitle:name url:destURL]);
        [self.audioRecorder prepareToRecord];
    } else {
        handler(NO, error);
    }
}

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (BOOL)playbackMemo:(TYMemo *)memo {
    [self.audioPlayer stop];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:memo.url error:nil];
    
    if (self.audioPlayer) {
        [self.audioPlayer play];
        return YES;
    }
    
    return NO;
}

#pragma mark -
- (NSString *)formattedCurrentTime {
    NSUInteger time = (NSUInteger)self.audioRecorder.currentTime;
    NSInteger hours = (time / 3600);
    NSInteger minutes = (time / 60) % 60;
    NSInteger seconds = time % 60;
    return [NSString stringWithFormat:@"%02li:%02li:%02li",(long)hours,(long)minutes,(long)seconds];
}

#pragma mark - <AVAudioRecorderDelegate>
// 录音完成或停止时被调用,如果被中断而停止,不调用此方法
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (self.stopCompletionHander) {
        self.stopCompletionHander(flag);
    }
}

@end
