
//
//  TYMemo.m
//  VoiceMemoDemo
//
//  Created by Maty on 2018/8/1.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import "TYMemo.h"

@interface TYMemo ()

@end

@implementation TYMemo

- (instancetype)init {
    if (self = [super init]) {
    
    }
    return self;
}

+ (TYMemo *)memoWithTitle:(NSString *)titleName url:(NSURL *)url {
    TYMemo *memo = [[TYMemo alloc] init];
    memo.name = titleName;
    memo.url = url;
    return memo;
}

@end
