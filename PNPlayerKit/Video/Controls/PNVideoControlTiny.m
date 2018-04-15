//
//  PNVideoControlTiny.m
//  PNPlayerKit
//
//  Created by Spud Hsu on 2018/4/14.
//  Copyright © 2018年 Spud Hsu. All rights reserved.
//

#import "PNVideoControlTiny.h"
#import <UIColor+Hex/UIColor+Hex.h>
#import <Masonry/Masonry.h>

@interface PNVideoControlTiny()
@property (nonatomic, strong, nonnull) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *lblTime;
@property (nonatomic, assign) BOOL started;
@property (nonatomic, strong) UIView *gradientView;
@property (nonatomic, strong) CALayer *gradientLayer;
@property (nonatomic, assign) NSInteger totalTime;
@end

@implementation PNVideoControlTiny

- (void)initViews{
    self.gradientView = [UIView new];
    self.gradientView.clipsToBounds = YES;
    [self addSubview:self.gradientView];
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, 54);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.colors = @[(__bridge id)[[UIColor colorWithHex:0x000000] colorWithAlphaComponent:0].CGColor,
                             (__bridge id)[[UIColor colorWithHex:0x000000] colorWithAlphaComponent:0.7019f].CGColor];
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    self.gradientLayer = gradientLayer;
    [self.gradientView.layer addSublayer:gradientLayer];
    [self.gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(54);
    }];
    
    self.lblTime = [UILabel new];
    self.lblTime.textAlignment = NSTextAlignmentCenter;
    self.lblTime.textColor = [UIColor whiteColor];
    self.lblTime.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    [self addSubview:self.lblTime];
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-9);
        make.bottom.mas_equalTo(-9);
    }];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.trackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.progressView.progressTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    [self addSubview:self.progressView];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
}


- (instancetype)init{
    if (self = [super init]) {
        [self initViews];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, 54);
}

- (void)setPlayingState:(BOOL)isPlaying{
    // do nothing
}


- (void)updateProgress:(float)progress{
    [self.progressView setProgress:progress];
}

- (void)setTotalTime:(NSInteger)totalTime{
    _totalTime = totalTime;
}

- (void)setCurrentTime:(NSInteger)currentTime{
    if (currentTime) {
        self.lblTime.text = [self timeStringWithSeconds:self.totalTime - currentTime];
    } else {
        self.lblTime.text = @"";
    }
}

-(void)reset{
    [self updateProgress:0];
    [self setCurrentTime:0];
}


- (NSString *)timeStringWithSeconds:(NSInteger)seconds{
    int dMinutes = floor(seconds % 3600 / 60);
    int dSeconds = floor(seconds % 3600 % 60);
    return [NSString stringWithFormat:@"%02i:%02i", dMinutes, dSeconds];
}
@end
