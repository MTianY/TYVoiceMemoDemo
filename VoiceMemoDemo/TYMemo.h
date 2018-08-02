//
//  TYMemo.h
//  VoiceMemoDemo
//
//  Created by Maty on 2018/8/1.
//  Copyright © 2018年 kangarootec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYMemo : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSURL *url;

+ (instancetype)memoWithTitle:(NSString *)titleName url:(NSURL *)url;

@end
