//
//  TYRecorderTool.h
//  VoiceMemoDemo
//
//  Created by Maty on 2018/8/1.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TYRecordingStopCompletionHandler)(BOOL);
typedef void(^TYRecordingSaveCompletionHandler)(BOOL, id);

@class TYMemo;
@interface TYRecorderTool : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, copy, readonly) NSString *formattedCurrentTime;

- (BOOL)record;
- (void)pause;

- (void)stopWithCompletionHandler:(TYRecordingStopCompletionHandler)handler;
- (void)saveRecordingWithName:(NSString *)name completionHandler:(TYRecordingSaveCompletionHandler)handler;

- (BOOL)playbackMemo:(TYMemo *)memo;

@end
