//
//  TYVoiceMemoHeaderView.h
//  VoiceMemoDemo
//
//  Created by Maty on 2018/8/1.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYVoiceMemoHeaderView : UIView

@property (nonatomic, strong) NSMutableArray *memoInstanceMutArray;
@property (nonatomic, strong) NSMutableArray *voiceNameMutArray;
@property (nonatomic, strong) NSMutableArray *voiceUrlMutArray;

- (void)startTimer;
- (void)stopTimer;

@end
