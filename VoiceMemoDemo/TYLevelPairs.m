//
//  TYLevelPairs.m
//  VoiceMemoDemo
//
//  Created by 马天野 on 2018/8/5.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import "TYLevelPairs.h"

@implementation TYLevelPairs

+ (TYLevelPairs *)levelsWithLevel:(float)linearLevel peakLevel:(float)peakLevel {
    TYLevelPairs *levelPairs = [[TYLevelPairs alloc] init];
    levelPairs.linearLevel = linearLevel;
    levelPairs.linearPeakLevel = peakLevel;
    return levelPairs;
}

@end
