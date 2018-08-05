//
//  TYLevelsView.m
//  VoiceMemoDemo
//
//  Created by 马天野 on 2018/8/5.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import "TYLevelsView.h"
#import "TYLevelPairs.h"

@implementation TYLevelsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - SET
- (void)setLevelPairs:(TYLevelPairs *)levelPairs {
    _levelPairs = levelPairs;
    
    float linearLevel = levelPairs.linearLevel;
    float peakLevel = levelPairs.linearPeakLevel;
    
    NSLog(@"linearLevel = %f \n peakLevel = %f",linearLevel, peakLevel);
    
}

#pragma mark - Method
- (void)resetLevelMeter {
    
}

#pragma mark - UI
- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
}

@end
