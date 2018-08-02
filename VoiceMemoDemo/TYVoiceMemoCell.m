//
//  TYVoiceMemoCell.m
//  VoiceMemoDemo
//
//  Created by Maty on 2018/8/1.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import "TYVoiceMemoCell.h"
#import "TYMemo.h"

#define TYSCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define TYSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface TYVoiceMemoCell ()

@property (nonatomic, strong) UILabel *cellTitileLabel;
@property (nonatomic, strong) UILabel *cellTimeLabel;

@end

@implementation TYVoiceMemoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - SET
- (void)setMemo:(TYMemo *)memo {
    _memo = memo;
    
    self.cellTitileLabel.text = [NSString stringWithFormat:@"%@",memo.name];
    
}

#pragma mark - UI
- (void)setupUI {
    
    self.cellTitileLabel.frame = CGRectMake(12, 15, 100, 30);
    [self addSubview:self.cellTitileLabel];
    
    self.cellTimeLabel.frame = CGRectMake(TYSCREEN_WIDTH - 12 - 100, 15, 100, 30);
    [self addSubview:self.cellTimeLabel];
    
}

#pragma mark - Lazy Load
- (UILabel *)cellTitileLabel {
    if (nil == _cellTitileLabel) {
        _cellTitileLabel = [[UILabel alloc] init];
        _cellTitileLabel.textColor = [UIColor lightGrayColor];
        _cellTitileLabel.font = [UIFont systemFontOfSize:14];
        _cellTitileLabel.textAlignment = NSTextAlignmentCenter;
//        _cellTitileLabel.text = @"Title";
    }
    return _cellTitileLabel;
}

- (UILabel *)cellTimeLabel {
    if (nil == _cellTimeLabel) {
        _cellTimeLabel = [[UILabel alloc] init];
        _cellTimeLabel.textColor = [UIColor lightGrayColor];
        _cellTimeLabel.font = [UIFont systemFontOfSize:14];
        _cellTimeLabel.textAlignment = NSTextAlignmentCenter;
//        _cellTimeLabel.text = @"Time";
    }
    return _cellTimeLabel;
}

@end
