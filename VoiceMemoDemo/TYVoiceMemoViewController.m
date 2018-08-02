//
//  TYVoiceMemoViewController.m
//  VoiceMemoDemo
//
//  Created by Maty on 2018/8/1.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import "TYVoiceMemoViewController.h"
#import "TYVoiceMemoCell.h"
#import "TYVoiceMemoHeaderView.h"
#import "TYRecorderTool.h"

#define TYSCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define TYSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

static NSString * const cellID = @"CellID";

@interface TYVoiceMemoViewController () <
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TYVoiceMemoHeaderView *headerView;

@end

@implementation TYVoiceMemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TYNotification_SaveVoiceSuccess:) name:@"TYNotification_SaveVoiceSuccess" object:nil];
    
}

#pragma mark - 通知方法
- (void)TYNotification_SaveVoiceSuccess:(NSNotification *)notif {
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *nameArra = self.headerView.voiceNameMutArray;
    NSLog(@"%@",nameArra);
    return nameArra.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYVoiceMemoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.memo = self.headerView.memoInstanceMutArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 250;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.headerView startTimer];
    
    TYMemo *memo = self.headerView.memoInstanceMutArray[indexPath.row];
    // 播放
    [[TYRecorderTool shareInstance] playbackMemo:memo];
}

#pragma mark - UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - Lazy Load
- (UITableView *)tableView {
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TYSCREEN_WIDTH, TYSCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[TYVoiceMemoCell class] forCellReuseIdentifier:cellID];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}

- (TYVoiceMemoHeaderView *)headerView {
    if (nil == _headerView) {
        _headerView = [[TYVoiceMemoHeaderView alloc] init];
    }
    return _headerView;
}

@end
