//
//  PNPlayerView.m
//  PNPlayerKit
//
//  Created by Spud Hsu on 2018/4/14.
//  Copyright © 2018年 Spud Hsu. All rights reserved.
//

#import "PNPlayerView.h"
#import "PNPlayer.h"
#import <Masonry/Masonry.h>
#import <AVFoundation/AVFoundation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "PNVideoControlTiny.h"
#import "PNVideoControlFull.h"

@interface PNPlayerView() <PNPlayerDelegate, PNVideoControlDelegate>
@property (nonatomic, strong, nonnull) UIImageView *imgPoster;
@property (nonatomic, strong, nonnull) UIButton *btnPlay;
@property (nonatomic, strong, nonnull) UIImageView *imgLoading;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) UIView<PNVideoControlProtocol> *control;
@property (nonatomic, assign) PNPlayerControlType controlType;
@property (nonatomic, assign) BOOL loading;
@end

@implementation PNPlayerView


- (instancetype)initWithControlType:(PNPlayerControlType)type{
    if (self = [super init]) {
        _controlType = type;
        [self initViews];
        [self initControl:type];
    }
    return self;
}

- (instancetype)init{
    return [self initWithControlType:PNPlayerControlTypeNone];
}

- (void)initViews{
    self.player = [PNPlayer new];
    self.player.delegate = self;
    [self addSubview:self.player];
    [self.player mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.imgPoster = [UIImageView new];
    self.imgPoster.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.imgPoster];
    [self.imgPoster mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.btnPlay = [UIButton new];
    [self.btnPlay setImage:[UIImage imageNamed:@"play-circle"] forState:UIControlStateNormal];
    [self addSubview:self.btnPlay];
    [self.btnPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(48);
    }];
    
    self.imgLoading = [UIImageView new];
    self.imgLoading.image = [UIImage imageNamed:@"loading"];
    self.imgLoading.clipsToBounds = YES;
    self.imgLoading.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.imgLoading];
    self.imgLoading.hidden = YES;
    [self.imgLoading mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.btnPlay);
    }];
    
    [self.btnPlay addTarget:self action:@selector(playButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self player:self.player statusDidChange:PNPlayerStatusPaused];
}

- (void)initControl:(PNPlayerControlType)type{
    if (type == PNPlayerControlTypeNone) {
        // do nothing
    } else if (type == PNPlayerControlTypeTiny) {
        self.control = [PNVideoControlTiny new];
        [self addSubview:self.control];
        [self.control mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(54);
            if (@available(iOS 11, *)) {
                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(self);
            }
        }];
    } else if (type == PNPlayerControlTypeSimple) {
        
    } else if (type == PNPlayerControlTypeFull) {
        self.control = [PNVideoControlFull new];
        [self addSubview:self.control];
        [self.control mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(44);
            if (@available(iOS 11, *)) {
                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(self);
            }
        }];
    }
    
    self.control.delegate = self;
}

- (void)playButtonTapped{
    if (self.player.status == PNPlayerStatusCompleted) {
        [self.player replay];
        [self.control reset];
    } else {
        [self.player play];
    }
    if ([self.delegate respondsToSelector:@selector(playerViewPlayButtonTapped:)]) {
        [self.delegate playerViewPlayButtonTapped:self];
    }
}

- (void)setVideo:(NSString *)video poster:(NSString *)poster {
    [self.player replaceURL:[NSURL URLWithString:video]];
    [self.imgPoster sd_setImageWithURL:[NSURL URLWithString:poster]];
}

- (NSInteger)currentTime {
    return self.player.currentTime;
}

- (NSInteger)totalTime {
    return self.player.totalTime;
}


- (BOOL)playing{
    return self.player.status == PNPlayerStatusPlaying;
}

- (void)play {
    [self.player play];
}

- (void)pause{
    [self.player pause];
}

- (void)seekTo:(CMTime)time{
    [self.player seekToTime:time];
    [self.player play];
}

- (void)startLoadingAnimation {
    if (self.loading) {
        return;
    }
    self.imgLoading.hidden = NO;
    self.loading = YES;
    // 一秒钟旋转几圈
    CGFloat circleByOneSecond = 4.0;
    // 执行动画
    [UIView animateWithDuration:1.f / circleByOneSecond
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.imgLoading.transform = CGAffineTransformRotate(self.imgLoading.transform, M_PI_2);
                     }
                     completion:^(BOOL finished){
                         if(finished){
                             self.loading = NO;
                             [self startLoadingAnimation];
                         }
                     }];
}

- (void)mute:(BOOL)shouldMute{
    [self.player setMuted:YES];
}

-(void)endLoadingAnimation {
    self.loading = NO;
    self.imgLoading.hidden = YES;
    [self.imgLoading.layer removeAllAnimations];
}

- (CGRect)fullScreenSize{
    CGFloat videoWidth = self.player.videoWidth;
    CGFloat videoHeight = self.player.videoHeight;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

    CGFloat width = 0;
    CGFloat height = 0;
    CGFloat left = 0;
    CGFloat top = 0;
    
    if (videoWidth > videoHeight) {
        width = screenWidth;
        height = width * 9.0f / 16.0f;
        left = 0;
        top = (screenHeight - height) / 2;
    } else {
        height = screenWidth;
        width = height * 9.0f / 16.0f;
        top = 0;
        left = screenWidth / 2;
    }
    
    return CGRectMake(left, top, width, height);
}



- (void)player:(PNPlayer *)player loadedTimeChanged:(NSInteger)loadedTime{
    if ([self.delegate respondsToSelector:@selector(playerView:loadedTimeChanged:)]) {
        [self.delegate playerView:self loadedTimeChanged:loadedTime];
    }
}

- (void)player:(PNPlayer *)player currentTimeChanged:(NSInteger)currentTime{
    [self.control setCurrentTime:currentTime];
    [self.control updateProgress:(float)currentTime / (float)player.totalTime];
    if ([self.delegate respondsToSelector:@selector(playerView:currentTimeChanged:)]) {
        [self.delegate playerView:self currentTimeChanged:currentTime];
    }
}

- (void)player:(nonnull PNPlayer *)player statusDidChange:(PNPlayerStatus)state {
    [self.control setTotalTime:player.totalTime];
    if (state == PNPlayerStatusBuffering) {
        self.player.hidden = NO;
        self.imgPoster.hidden = YES;
        self.btnPlay.hidden = YES;
        [self startLoadingAnimation];
    }
    
    if(state == PNPlayerStatusPlaying){
        self.player.hidden = NO;
        self.imgPoster.hidden = YES;
        self.btnPlay.hidden = YES;
        [self endLoadingAnimation];
    }
    
    if(state == PNPlayerStatusCompleted || state == PNPlayerStatusPaused){
        self.player.hidden = NO;
        self.imgPoster.hidden = self.player.currentTime != 0;
        if (state == PNPlayerStatusPaused && _controlType == PNPlayerControlTypeFull) {
            self.btnPlay.hidden = YES;
        } else {
            self.btnPlay.hidden = NO;
        }
        if (state == PNPlayerStatusCompleted) {
            [self.btnPlay setImage:[UIImage imageNamed:@"replay"] forState:UIControlStateNormal];
        } else {
            [self.btnPlay setImage:[UIImage imageNamed:@"play-circle"] forState:UIControlStateNormal];
        }
        [self endLoadingAnimation];
    }
    
    [self.control setPlayingState:[self playing]];
    
    if ([self.delegate respondsToSelector:@selector(playerView:statusDidChange:)]) {
        [self.delegate playerView:self statusDidChange:state];
    }
}

- (void)videoControlTapPlay{
    [self play];
}

- (void)videoControlTapPause{
    [self pause];
}

- (void)videoControlTransformOrientation:(UIDeviceOrientation)orientation{
    
}

- (void)videoControlMoveProgress:(CGFloat)progress{
    [self.player seekToTime:CMTimeMake(progress * self.player.totalTime, 1)];
    [self.player play];
}
@end
