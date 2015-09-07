//
//  ViewController.m
//  HYZCustomBannerViewController
//
//  Created by emp.heng on 15/9/7.
//  Copyright (c) 2015年 emp.heng. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "HYZCustomBannerView.h"

@interface ViewController ()<HYZCustomBannerViewDelegate>

@property (nonatomic, strong) HYZCustomBannerView *bannerView;

@end

@implementation ViewController

- (HYZCustomBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[HYZCustomBannerView alloc] init];
        _bannerView.delegate = self;
    }
    return _bannerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *imageArray = @[@"banner_", @"sqz_banner_morentu", @"banner_"];
    
    [self.view addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.height.mas_equalTo(@(100));
    }];
    self.bannerView.imageArray = imageArray;
    [self.bannerView configObject:nil];
}


#pragma mark --HYZCustomBannerViewDelegate

- (void)disSelectAtIndex:(NSInteger)index andView:(HYZCustomBannerView *)view {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"第%ld页被选中", index + 1] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
