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
@property (nonatomic, strong) UISlider *progressView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIButton *btnTransform;
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
    self.lblTime.text = @"00:00";
    self.lblTime.textColor = [UIColor whiteColor];
    
    [self addSubview:self.lblTime];
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(14);
    }];
    
    self.btnTransform = [UIButton new];
    self.btnTransform.contentMode = UIViewContentModeCenter;
    [self.btnTransform setImage:[UIImage imageNamed:@"player-transform"] forState:UIControlStateNormal];
    [self addSubview:self.btnTransform];
    [self.btnTransform mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(44);
        make.top.mas_equalTo(-11);
        make.right.equalTo(self).offset(-0);
    }];
    [self.btnTransform addTarget:self action:@selector(transformButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.progressView = [[UISlider alloc] init];
    self.progressView.maximumValue = 1;
    self.progressView.minimumValue = 0;
    self.progressView.layer.cornerRadius = 1;
    self.progressView.layer.masksToBounds = YES;
    self.progressView.maximumTrackTintColor = [UIColor whiteColor];
    self.progressView.minimumTrackTintColor = [UIColor colorWithHex:0xebb84b];
    
    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(-1);
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width, 44);
}

- (void)seekToProgress:(UISlider *)sender {
    if(self.delegate){
        [self.delegate videoControlMoveProgress:sender.value];
    }
}

- (void)updateProgress:(float)progress {
    [self.progressView setValue:progress];
}

- (void)setTotalTime:(NSInteger)totalTime {
    self.lblTime.text = [self getTimeString:totalTime];
    if (totalTime == 0) {
        [self updateProgress:0];
        [self setCurrentTime:0];
    }
}

- (void)setCurrentTime:(NSInteger)currentTime {
    self.lblTime.text = [self getTimeString:currentTime];
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

