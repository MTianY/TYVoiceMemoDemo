//
//  TYLevelsView.m
//  VoiceMemoDemo
//
//  Created by 马天野 on 2018/8/5.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import "TYLevelsView.h"
#import "TYLevelPairs.h"
#import "TYRecorderTool.h"

@implementation TYLevelsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - DRAW RECT
- (void)drawRect:(CGRect)rect {
    
    TYLevelPairs *pairs = [[TYRecorderTool shareInstance] levels];
    float linearLevel = pairs.linearLevel;
    float peakLevel = pairs.linearPeakLevel;
    NSLog(@"\n linearLevel=%f \n peakLevel=%f",linearLevel,peakLevel);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = 1;
    
    [bezierPath moveToPoint:CGPointMake(10, 10)];
    [bezierPath addLineToPoint:CGPointMake(linearLevel, peakLevel)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor greenColor].CGColor;
    shapeLayer.path = bezierPath.CGPath;
    [self.layer addSublayer:shapeLayer];
    
}

#pragma mark - Method
- (void)resetLevelMeter {
    
}

#pragma mark - UI
- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
}

@end
