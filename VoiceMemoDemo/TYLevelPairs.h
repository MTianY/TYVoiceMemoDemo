//
//  TYLevelPairs.h
//  VoiceMemoDemo
//
//  Created by 马天野 on 2018/8/5.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYLevelPairs : NSObject

// 平均值
@property (nonatomic, assign) float linearLevel;
// 峰值
@property (nonatomic, assign) float linearPeakLevel;

+ (TYLevelPairs *)levelsWithLevel:(float)linearLevel peakLevel:(float)peakLevel;

@end
