//
//  TYMeterTable.m
//  VoiceMemoDemo
//
//  Created by 马天野 on 2018/8/5.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import "TYMeterTable.h"

#define MIN_DB -60.0f
#define TABLE_SIZE 300

@interface TYMeterTable ()

@end

@implementation TYMeterTable {
    // 解析率 -0.2dB
    float _scaleFactor;
    NSMutableArray *_meterTable;
}

- (instancetype)init {
    if (self = [super init]) {
        
        float dbResolution = MIN_DB / (TABLE_SIZE - 1);
        _meterTable = [NSMutableArray arrayWithCapacity:TABLE_SIZE];
        _scaleFactor = 1.0f / dbResolution;
        
        float minAmp = dbToAmp(MIN_DB);
        float ampRange = 1.0 - minAmp;
        float invAmpRange = 1.0 / ampRange;
        
        for (int i = 0; i < TABLE_SIZE; i++) {
            float decibels = i * dbResolution;
            float amp = dbToAmp(decibels);
            float adjAmp = (amp - minAmp) * invAmpRange;
            _meterTable[i] = @(adjAmp);
        }
        
    }
    return self;
}

/**
 * 将分贝值转换为线性范围内的值,使其处于范围 0(-60dB) 到 1 之间,
 * 之后得到一条由这些范围内的值构成的平滑曲线,开平方计算并保存到内部查找表格中.
 * 这些值之后可以通过 valueForPower: 方法获取
 */
float dbToAmp(float dB) {
    return powf(10.0f, 0.05f * dB);
}

- (float)valueForPower:(float)power {
    if (power < MIN_DB) {
        return 0.0f;
    } else if (power >= 0.0f) {
        return 1.0f;
    } else {
        int index = (int)(power * _scaleFactor);
        return [_meterTable[index] floatValue];
    }
}

@end
