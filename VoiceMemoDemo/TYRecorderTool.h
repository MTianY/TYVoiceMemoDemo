//
//  TYRecorderTool.h
//  VoiceMemoDemo
//
//  Created by Maty on 2018/8/1.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYLevelPairs.h"

typedef void(^TYRecordingStopCompletionHandler)(BOOL);
typedef void(^TYRecordingSaveCompletionHandler)(BOOL, id);
typedef void(^TYAudioPlayerStopPlayingCompletionHandler)(BOOL);

@class TYMemo;
@interface TYRecorderTool : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, copy, readonly) NSString *formattedCurrentTime;
@property (nonatomic, copy) TYAudioPlayerStopPlayingCompletionHandler audioPlayerStopPlayingCompletionHandler;

- (BOOL)record;
- (void)pause;

- (void)stopWithCompletionHandler:(TYRecordingStopCompletionHandler)handler;
- (void)saveRecordingWithName:(NSString *)name completionHandler:(TYRecordingSaveCompletionHandler)handler;

- (BOOL)playbackMemo:(TYMemo *)memo;
- (void)audioPlayerStopPlaying:(TYAudioPlayerStopPlayingCompletionHandler)stopPlayingHandler;

- (TYLevelPairs *)levels;

@end
