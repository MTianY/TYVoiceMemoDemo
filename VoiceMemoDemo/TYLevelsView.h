//
//  TYLevelsView.h
//  VoiceMemoDemo
//
//  Created by 马天野 on 2018/8/5.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYLevelPairs;
@interface TYLevelsView : UIView

// 平均值
@property (nonatomic, assign) float level;
// 峰值
@property (nonatomic, assign) float peakLevel;
@property (nonatomic, strong) TYLevelPairs *levelPairs;

- (void)resetLevelMeter;

@end
