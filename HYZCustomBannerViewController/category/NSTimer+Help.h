//
//  NSTimer+Help.h
//  HYZCustomBannerViewController
//
//  Created by emp.heng on 15/9/7.
//  Copyright (c) 2015年 emp.heng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Help)
- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
