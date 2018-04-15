//
//  PNVideoControlFull.m
//  PNPlayerKit
//
//  Created by Spud Hsu on 2018/4/14.
//  Copyright © 2018年 Spud Hsu. All rights reserved.
//

#import "PNVideoControlFull.h"
#import <Masonry/Masonry.h>
#import <UIColor+Hex/UIColor+Hex.h>

@interface PNVideoControlFull()
@property (nonatomic, strong) UILabel *labCurrentTime;
@property (nonatomic, strong) UILabel *labTotalTime;
@property (nonatomic, strong) UISlider *progressView;
@property (nonatomic, strong) UIButton *btnPlay;
@property (nonatomic, strong) UIButton *btnTransform;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation PNVideoControlFull

- (instancetype)init{
    if(self = [super init]){
        [self load];
    }
    return self;
}

- (void)playButtonTapped{
    if(self.delegate){
        if(self.isPlaying){
            [self.delegate videoControlTapPause];
        }else{
            [self.delegate videoControlTapPlay];
        }
    }
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
    self.isPlaying = NO;
    
    self.backgroundColor = [UIColor clearColor];
    
    //    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.layer addSublayer:self.gradientLayer];
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    self.gradientLayer.startPoint = CGPointMake(0, 1);
    self.gradientLayer.endPoint = CGPointMake(0, 0);
    //
    //    //设置颜色数组
    self.gradientLayer.colors = @[(__bridge id)[[UIColor colorWithHex:0x000000] colorWithAlphaComponent:0.4].CGColor,
                                  (__bridge id)[[UIColor colorWithHex:0x000000] colorWithAlphaComponent:0].CGColor];
    //设置颜色分割点（范围：0-1）
    self.gradientLayer.locations = @[@(0.0f), @(1.0f)];
    
    self.btnPlay = [UIButton new];
    self.btnPlay.contentMode = UIViewContentModeCenter;
    [self.btnPlay setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self addSubview:self.btnPlay];
    [self.btnPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(44);
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(5);
    }];
    [self.btnPlay addTarget:self action:@selector(playButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnTransform = [UIButton new];
    self.btnTransform.contentMode = UIViewContentModeCenter;
    [self.btnTransform setImage:[UIImage imageNamed:@"player-transform"] forState:UIControlStateNormal];
    [self addSubview:self.btnTransform];
    [self.btnTransform mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(44);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-5);
    }];
    
    [self.btnTransform addTarget:self action:@selector(transformButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.labCurrentTime = [UILabel new];
    self.labCurrentTime.text = @"00:00";
    self.labCurrentTime.textAlignment = NSTextAlignmentCenter;
    self.labCurrentTime.textColor = [UIColor colorWithHex:0xffffff];
    self.labCurrentTime.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    [self addSubview:self.labCurrentTime];
    [self.labCurrentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(50);
        make.centerY.equalTo(self);
        make.left.equalTo(self.btnPlay.mas_right).offset(5);
    }];
    
    self.labTotalTime = [UILabel new];
    self.labTotalTime.text = @"00:00";
    self.labTotalTime.textAlignment = NSTextAlignmentCenter;
    self.labTotalTime.textColor = [UIColor whiteColor];
    self.labTotalTime.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    [self addSubview:self.labTotalTime];
    [self.labTotalTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(50);
        make.centerY.equalTo(self);
        make.right.equalTo(self.btnTransform.mas_left).offset(-5);
    }];
    
    self.progressView = [[UISlider alloc] init];
    self.progressView.maximumValue = 1;
    self.progressView.minimumValue = 0;
    self.progressView.layer.cornerRadius = 1;
    self.progressView.layer.masksToBounds = YES;
    self.progressView.maximumTrackTintColor = [UIColor whiteColor];
    self.progressView.minimumTrackTintColor = [UIColor colorWithHex:0xebb84b];
    
    [self.progressView setThumbImage:[UIImage imageNamed:@"oval4"] forState:UIControlStateNormal];
    [self.progressView addTarget:self action:@selector(seekToProgress:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.mas_equalTo(40);
        make.left.equalTo(self.labCurrentTime.mas_right);
        make.right.equalTo(self.labTotalTime.mas_left);
    }];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width, 44);
}

-(void)seekToProgress:(UISlider *)sender {
    if(self.delegate){
        [self.delegate videoControlMoveProgress:sender.value];
    }
}

-(void)setPlayingState:(BOOL)isPlaying{
    if(isPlaying){
        [self.btnPlay setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }else{
        [self.btnPlay setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    self.isPlaying = isPlaying;
}

-(void)updateProgress:(float)progress {
    [self.progressView setValue:progress];
}

- (void)setTotalTime:(NSInteger)totalTime {
    self.labTotalTime.text = [self getTimeString:totalTime];
    if (totalTime == 0) {
        [self updateProgress:0];
        [self setCurrentTime:0];
    }
}

- (void)setCurrentTime:(NSInteger)currentTime {
    self.labCurrentTime.text = [self getTimeString:currentTime];
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
