//
//  HYZCustomBannerView.m
//  HYZCustomBannerViewController
//
//  Created by emp.heng on 15/9/7.
//  Copyright (c) 2015年 emp.heng. All rights reserved.
//

#import "HYZCustomBannerView.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>
#import "NSTimer+Help.h"

static NSTimeInterval const KALBannerViewAnimationDuration = 2.0;
static NSTimeInterval const KALBannerTransferAnimationDuration = 0.7;
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface HYZCustomBannerView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic) NSInteger currentPage;

@end

@implementation HYZCustomBannerView

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.delegate = self;
        _mainScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.mainScrollView.frame), 0);
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.clipsToBounds = YES;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _mainScrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:250/255.0 green:200/255.0 blue:0/255.0 alpha:1.0];
    }
    return _pageControl;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        UIImage *closeImage = [UIImage imageNamed:@"comm_grzx_icon_delete_slt"];
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:closeImage forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.autoresizesSubviews = YES;
        self.backgroundColor = [UIColor clearColor];
        self.currentPage = 1;
        [self initUI];
    }
    return self;
}

- (void)viewWillAppear {
}

- (void)initUI {
    [self addSubview:self.mainScrollView];
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_height);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    
    [self addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).with.offset(-6);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(8));
    }];
    
    if (self.showCloseButton) {
        [self addSubview:self.closeButton];
        UIImage *closeImage = [UIImage imageNamed:@""];
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-8);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@(closeImage.size.width + 10));
            make.height.equalTo(self.mas_height);
        }];
        [self bringSubviewToFront:self.closeButton];
    }
}

- (void)viewDidAppear {
    [_animationTimer resumeTimer];
}

- (void)viewWillDisAppear {
    [_animationTimer pauseTimer];
}

- (void)bannerPageClick:(UITapGestureRecognizer *)tapGesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(disSelectAtIndex:andView:)]) {
        [self.delegate disSelectAtIndex:(tapGesture.view.tag - 1) andView:self];
    }
}

- (void)closeButtonClick {
    [_animationTimer pauseTimer];
}


#pragma mark --定时器

- (void)invalidTimer {
    if (_animationTimer) {
        [_animationTimer invalidate];
    }
    _animationTimer = nil;
}

- (void)animationTimerDidFired {
    if (self.currentPage == self.imageArray.count) {
        self.mainScrollView.contentOffset = CGPointMake(0, 0);
    }
    
    self.currentPage++;
    if (self.currentPage == self.imageArray.count + 1) {
        self.currentPage = 1;
    }
    
    [UIView animateWithDuration:KALBannerTransferAnimationDuration animations:^{
        self.mainScrollView.contentOffset = CGPointMake(ScreenWidth * self.currentPage, 0);
    }];
    self.pageControl.currentPage = self.currentPage - 1;
}

- (void)configObject:(id )object {
    [self invalidTimer];
    _animationTimer = [NSTimer scheduledTimerWithTimeInterval:KALBannerViewAnimationDuration target:self selector:@selector(animationTimerDidFired) userInfo:nil repeats:YES];
    
    [self.pageControl setNumberOfPages:self.imageArray.count];
    self.pageControl.currentPage = self.currentPage - 1;
    for ( int i = 0; i < (self.imageArray.count + 2); i++) {
        NSString *imageUrl = @"";
        if (i == 0) {
            imageUrl = [self.imageArray lastObject];
        } else if(i < self.imageArray.count + 1) {
            imageUrl = [self.imageArray objectAtIndex:(i - 1)];
        } else {
            imageUrl = self.imageArray[0];
        }
        [self addImageViewAtIndex:i inView:self.mainScrollView andUrl:imageUrl];
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.mainScrollView.contentSize = CGSizeMake(screenWidth * (self.imageArray.count + 2), self.frame.size.height);
    self.mainScrollView.contentOffset = CGPointMake(screenWidth, 0);
}

- (void)addImageViewAtIndex:(NSInteger)index inView:(UIView *)view andUrl:(NSString *)url {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleToFill;
//    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"sqz_banner_morentu"]];
    imageView.image = [UIImage imageNamed:url];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    if (index == 0) {
        imageView.tag = self.imageArray.count;
    } else if(index == self.imageArray.count + 1) {
        imageView.tag = 1;
    } else {
        imageView.tag = index;
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerPageClick:)];
    [imageView addGestureRecognizer:tapGesture];
    [view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mainScrollView.mas_width);
        make.height.equalTo(self.mainScrollView.mas_height);
        make.centerY.equalTo(self.mainScrollView.mas_centerY);
        make.left.equalTo(@([UIScreen mainScreen].bounds.size.width * index));
    }];
}


#pragma mark --UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_animationTimer resumeTimerAfterTimeInterval:KALBannerViewAnimationDuration];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = self.mainScrollView.contentOffset.x;
    int index = offsetX/ScreenWidth;
    if (index == 0) {
        [self.mainScrollView setContentOffset:CGPointMake(ScreenWidth*self.imageArray.count, 0) animated:NO];
        self.pageControl.currentPage = self.imageArray.count - 1;
    } else if (index == self.imageArray.count + 2 -1){
        [self.mainScrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:NO];
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage = index - 1;
    }
    self.currentPage = self.pageControl.currentPage + 1;
}

- (void)dealloc {
    [self invalidTimer];
    [self.mainScrollView removeFromSuperview];
    [self.pageControl removeFromSuperview];
    if (self.showCloseButton) {
        [self.closeButton removeFromSuperview];
        self.closeButton = nil;
    }
    self.mainScrollView = nil;
    self.pageControl = nil;
    
}

@end
