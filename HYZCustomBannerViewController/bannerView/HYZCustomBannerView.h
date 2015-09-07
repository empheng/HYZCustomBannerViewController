//
//  HYZCustomBannerView.h
//  HYZCustomBannerViewController
//
//  Created by emp.heng on 15/9/7.
//  Copyright (c) 2015年 emp.heng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYZCustomBannerView;

@protocol HYZCustomBannerViewDelegate <NSObject>

@optional
- (void)didClose:(HYZCustomBannerView *)view;
- (void)disSelectAtIndex:(NSInteger)index andView:(HYZCustomBannerView *)view;
- (void)disScroll:(HYZCustomBannerView *)view;

@end

@interface HYZCustomBannerView : UIView

@property (nonatomic, weak) id <HYZCustomBannerViewDelegate> delegate;
@property (nonatomic) BOOL showCloseButton;
@property (nonatomic, strong) NSString *targetUrl;
@property (nonatomic, strong) NSString *detailNavTitle;
@property (nonatomic, strong) NSArray *imageArray;

- (void)viewDidAppear;
- (void)viewWillDisAppear;
- (void)configObject:(id)object;

@end
