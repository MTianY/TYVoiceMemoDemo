//
//  TYVoiceMemoCell.m
//  VoiceMemoDemo
//
//  Created by Maty on 2018/8/1.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import "TYVoiceMemoCell.h"
#import "TYMemo.h"
#import "TYRecorderTool.h"

#define TYSCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define TYSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface TYVoiceMemoCell ()

@property (nonatomic, strong) UILabel *cellTitileLabel;
@property (nonatomic, strong) UILabel *cellTimeLabel;

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation TYVoiceMemoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

#pragma mark - SET
- (void)setMemo:(TYMemo *)memo {
    _memo = memo;
    
    self.cellTitileLabel.text = [NSString stringWithFormat:@"%@",memo.name];
    
}

#pragma mark - Button Method
- (void)playBtnClick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [button setSelected:YES];
        [button setImage:[UIImage imageNamed:@"cell-pause1"] forState:UIControlStateNormal];
        
        [[TYRecorderTool shareInstance] playbackMemo:self.memo];
        
    } else {
        [button setSelected:NO];
        [button setImage:[UIImage imageNamed:@"cell-play"] forState:UIControlStateSelected];
        
        
        
    }
}

- (void)deleteBtnClick:(UIButton *)button {
    
}

#pragma mark - UI
- (void)setupUI {
    
    self.cellTitileLabel.frame = CGRectMake(20, 15, 100, 30);
    [self addSubview:self.cellTitileLabel];
    
    self.cellTimeLabel.frame = CGRectMake(TYSCREEN_WIDTH - 12 - 100, 15, 100, 30);
    [self addSubview:self.cellTimeLabel];
    
    self.playBtn.frame = CGRectMake(20, 60 + 5, 20, 20);
    [self addSubview:self.playBtn];
    
    self.deleteBtn.frame = CGRectMake(TYSCREEN_WIDTH - 20 - 20, 60 + 5, 20, 20);
    [self addSubview:self.deleteBtn];
    
}

#pragma mark - Lazy Load
- (UILabel *)cellTitileLabel {
    if (nil == _cellTitileLabel) {
        _cellTitileLabel = [[UILabel alloc] init];
        _cellTitileLabel.textColor = [UIColor lightGrayColor];
        _cellTitileLabel.font = [UIFont systemFontOfSize:14];
        _cellTitileLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _cellTitileLabel;
}

- (UILabel *)cellTimeLabel {
    if (nil == _cellTimeLabel) {
        _cellTimeLabel = [[UILabel alloc] init];
        _cellTimeLabel.textColor = [UIColor lightGrayColor];
        _cellTimeLabel.font = [UIFont systemFontOfSize:14];
        _cellTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _cellTimeLabel;
}

- (UIButton *)playBtn {
    if (nil == _playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"cell-play"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)deleteBtn {
    if (nil == _deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

@end
