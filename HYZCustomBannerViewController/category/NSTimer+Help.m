//
//  NSTimer+Help.m
//  HYZCustomBannerViewController
//
//  Created by emp.heng on 15/9/7.
//  Copyright (c) 2015年 emp.heng. All rights reserved.
//

#import "NSTimer+Help.h"

@implementation NSTimer (Help)
- (void)pauseTimer {
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resumeTimer {
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval {
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}
@end
