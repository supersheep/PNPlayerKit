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
#import "PNVideoHeadControl.h"

@interface PNPlayerView() <PNPlayerDelegate, PNVideoControlDelegate, PNVideoHeadControlDelegate>
@property (nonatomic, strong, nonnull) UIImageView *imgPoster;
@property (nonatomic, strong, nonnull) UIButton *btnPlay;
@property (nonatomic, strong, nonnull) UIImageView *imgLoading;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) UIView<PNVideoControlProtocol> *control;
@property (nonatomic, assign) PNPlayerControlType controlType;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, assign) BOOL isShowControl;
@property (nonatomic, strong) PNVideoHeadControl *head;
@property (nonatomic, assign) CGRect originFrame;
@end

@implementation PNPlayerView


- (instancetype)initWithControlType:(PNPlayerControlType)type{
    if (self = [super init]) {
        _controlType = type;
        [self initViews];
        [self setControlType:type];
    }
    return self;
}

- (instancetype)init{
    return [self initWithControlType:PNPlayerControlTypeNone];
}

- (void)initViews{
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor blackColor];
    self.player = [PNPlayer new];
    self.player.delegate = self;
    [self addSubview:self.player];
    [self.player mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.imgPoster = [UIImageView new];
    self.imgPoster.contentMode = UIViewContentModeScaleAspectFit;
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
    
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playerTapped)];
    [self addGestureRecognizer:tap];
    
//    self.btnClose.hidden = YES;
    
    
    [self player:self.player statusDidChange:PNPlayerStatusPaused];
}

- (void)setControlType:(PNPlayerControlType)type{
    _controlType = type;
    _isShowControl = YES;
    [self.control removeFromSuperview];
    [self.head removeFromSuperview];
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
        
        self.head = [PNVideoHeadControl new];
        self.head.delegate = self;
        [self addSubview:self.head];
        [self.head mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(44);
            make.left.right.top.equalTo(self);
        }];
    }
    
    self.control.delegate = self;
}


- (void)setVideo:(NSString *)video poster:(NSString *)poster {
    [self.player replaceURL:[NSURL URLWithString:video]];
    [self.imgPoster sd_setImageWithURL:[NSURL URLWithString:poster]];
}

#pragma mark - event handlers
- (void)playerTapped{
    if (self.controlType == PNPlayerControlTypeFull) {
        [self toggleControl];
    } else {
        if ([self.delegate respondsToSelector:@selector(playerViewTapped:)]) {
            [self.delegate playerViewTapped:self];
        }
    }
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


#pragma mark - controls
- (void)showControl {
    
    [UIView animateWithDuration:0.6
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:2.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.head mas_remakeConstraints:^(MASConstraintMaker *make) {
                             make.left.right.equalTo(self);
                             make.height.mas_equalTo(44);
                             make.top.equalTo(self).offset(0);
                         }];
                         
                         [self.control mas_remakeConstraints:^(MASConstraintMaker *make) {
                             make.left.right.equalTo(self);
                             make.bottom.equalTo(self);
                             make.height.mas_equalTo(44);
                         }];
                         
                         [self layoutIfNeeded];
                     } completion:nil];
}

- (void)hideControl {
    [UIView animateWithDuration:0.6
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:2.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.head mas_remakeConstraints:^(MASConstraintMaker *make) {
                             make.left.right.equalTo(self);
                             make.height.mas_equalTo(44);
                             make.top.equalTo(self).offset(-44);
                         }];
                         
                         [self.control mas_remakeConstraints:^(MASConstraintMaker *make) {
                             make.left.right.equalTo(self);
                             make.bottom.equalTo(self).offset(44);
                             make.height.mas_equalTo(44);
                         }];
                         
                         [self layoutIfNeeded];
                     } completion:nil];
}

- (void)toggleControl {
    if (self.controlType != PNPlayerControlTypeFull) {
        return;
    }
    
    self.isShowControl = !self.isShowControl;
    if (self.isShowControl) {
        [self showControl];
    } else {
        [self hideControl];
    }
}


#pragma mark - getters
- (NSInteger)currentTime {
    return self.player.currentTime;
}

- (NSInteger)totalTime {
    return self.player.totalTime;
}

- (BOOL)playing{
    return self.player.status == PNPlayerStatusPlaying;
}

#pragma mark - public funcs
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

- (void)mute:(BOOL)shouldMute{
    [self.player setMuted:YES];
}

#pragma mark - private funcs
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

-(void)endLoadingAnimation {
    self.loading = NO;
    self.imgLoading.hidden = YES;
    [self.imgLoading.layer removeAllAnimations];
}


- (void)fullScreen{
    [UIView animateWithDuration:0.5 animations:^{
        self.originFrame = self.frame;
        self.player.orientation = PNPlayerOrientationLandscape;
        [self changeOrientation:PNPlayerOrientationLandscape];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }];
}

- (void)quitFullScreen{
    [UIView animateWithDuration:0.5 animations:^{
        self.player.orientation = PNPlayerOrientationPortrait;
        [self changeOrientation:PNPlayerOrientationPortrait];
        self.frame = self.originFrame;
    }];
}


- (void)changeOrientation:(PNPlayerOrientation)orientation{
    CGAffineTransform trans;
    trans = CGAffineTransformMakeTranslation(0, 0);
    
    if (orientation == PNPlayerOrientationLandscape) {
        trans = CGAffineTransformRotate(trans, M_PI / 2);
    } else {
        trans = CGAffineTransformRotate(trans, 0);
    }
    self.transform = trans;
}

#pragma mark - player delegate
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

#pragma mark - video control delegate
- (void)videoControlTapTransform{
    self.player.orientation = self.player.orientation == PNPlayerOrientationPortrait ? PNPlayerOrientationLandscape : PNPlayerOrientationPortrait;
    
    if (self.player.orientation == PNPlayerOrientationPortrait) {
        [self quitFullScreen];
    } else {
        [self fullScreen];
    }
}

- (void)videoControlTapPlay{
    [self play];
}

- (void)videoControlTapPause{
    [self pause];
}

- (void)videoControlMoveProgress:(CGFloat)progress{
    [self.player seekToTime:CMTimeMake(progress * self.player.totalTime, 1)];
    [self.player play];
}

#pragma mark - head control delegate
- (void)videoHeadControlCloseTapped{
    [self quitFullScreen];
    if ([self.delegate respondsToSelector:@selector(playerViewCloseButtonTapped:)]) {
        [self.delegate playerViewCloseButtonTapped:self];
    }
}

@end
