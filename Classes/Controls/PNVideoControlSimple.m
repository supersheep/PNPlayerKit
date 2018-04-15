//
//  PNVideoControlFull.m
//  PNPlayerKit
//
//  Created by Spud Hsu on 2018/4/14.
//  Copyright © 2018年 Spud Hsu. All rights reserved.
//

#import "PNVideoControlSimple.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@interface PNVideoControlSimple()
@property (nonatomic, strong) UILabel *lblTime;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIButton *btnTransform;
@property (nonatomic, assign) NSInteger totalTime;
@end

@implementation PNVideoControlSimple

- (instancetype)init{
    if(self = [super init]){
        [self load];
    }
    return self;
}

- (void)transformButtonTapped{
    if([self.delegate respondsToSelector:@selector(videoControlTapTransform)]){
        [self.delegate videoControlTapTransform];
    }
}

- (void)updateOrientation:(PNPlayerOrientation)orientation{
    //    self.btnTransform
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, 44);
}

- (void)load{
    self.backgroundColor = [UIColor clearColor];
    // 初始化CAGradientlayer对象，使它的大小为UIView的大小
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    // 将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.layer addSublayer:self.gradientLayer];
    
    // 设置渐变区域的起始和终止位置（范围为0-1）
    self.gradientLayer.startPoint = CGPointMake(0, 1);
    self.gradientLayer.endPoint = CGPointMake(0, 0);
    
    //
    // 设置颜色数组
    self.gradientLayer.colors = @[(__bridge id)[[UIColor colorWithHex:0x000000] colorWithAlphaComponent:0.4].CGColor,
                                  (__bridge id)[[UIColor colorWithHex:0x000000] colorWithAlphaComponent:0].CGColor];
    //设置颜色分割点（范围：0-1）
    self.gradientLayer.locations = @[@(0.0f), @(1.0f)];
    
    self.lblTime = [UILabel new];
    self.lblTime.text = @"00:00/00:00";
    self.lblTime.textColor = [UIColor whiteColor];
    
    [self addSubview:self.lblTime];
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(14);
    }];
    
    self.btnTransform = [UIButton new];
    self.btnTransform.contentMode = UIViewContentModeCenter;
    [self.btnTransform setImage:[UIImage imageNamed:@"player-transform"] forState:UIControlStateNormal];
    [self addSubview:self.btnTransform];
    [self.btnTransform mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(44);
        make.top.mas_equalTo(-2);
        make.right.equalTo(self).offset(0);
    }];
    [self.btnTransform addTarget:self action:@selector(transformButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.trackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.progressView.progressTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    
    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(-1);
    }];
}

- (void)seekToProgress:(UISlider *)sender {
    if(self.delegate){
        [self.delegate videoControlMoveProgress:sender.value];
    }
}

- (void)updateProgress:(float)progress {
    [self.progressView setProgress:progress];
}

- (void)setTotalTime:(NSInteger)totalTime {
    _totalTime = totalTime;
    if (totalTime == 0) {
        [self updateProgress:0];
        [self setCurrentTime:0];
    }
}

- (void)setCurrentTime:(NSInteger)currentTime {
    if (!currentTime || !_totalTime) { return; }
    self.lblTime.text = [NSString stringWithFormat:@"%@/%@", [self getTimeString:currentTime], [self getTimeString:_totalTime]];
}

- (NSString *)getTimeString:(NSInteger)dTotalSeconds{
    int dMinutes = floor(dTotalSeconds % 3600 / 60);
    int dSeconds = floor(dTotalSeconds % 3600 % 60);
    return [NSString stringWithFormat:@"%02i:%02i", dMinutes, dSeconds];
}

- (void)reset{
    [self updateProgress:0];
    [self setTotalTime:0];
    [self setCurrentTime:0];
}


@end

