//
//  TYVoiceMemoCell.h
//  VoiceMemoDemo
//
//  Created by Maty on 2018/8/1.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cellPlayButtonClickCallBack)(void);
typedef void(^cellPauseButtonClickCallBack)(void);
typedef void(^cellDeleteButtonClickCallBack)(void);

@class TYMemo;
@interface TYVoiceMemoCell : UITableViewCell
@property (nonatomic, strong) TYMemo *memo;

@property (nonatomic, copy) cellPlayButtonClickCallBack playBtnCallBack;
@property (nonatomic, copy) cellPauseButtonClickCallBack pauseBtnCallBack;
@property (nonatomic, copy) cellDeleteButtonClickCallBack deleteBtnCallBack;

@end
