//
//  PNPlayer.m
//  PNPlayerKit
//
//  Created by Spud Hsu on 2018/4/14.
//  Copyright © 2018年 Spud Hsu. All rights reserved.
//
#import "PNPlayer.h"
#import "PNAssetManager.h"

static PNPlayer *currentPlayer = nil;

@interface PNPlayer()
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic ,strong)  id timeObserver;
@end

@implementation PNPlayer

- (instancetype)init{
    if (self = [super init]) {
        self.player = [AVPlayer new];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        self.playerLayer.player = self.player;
        self.playerLayer.frame = self.bounds;
        [self.playerLayer displayIfNeeded];
        [self.layer addSublayer:self.playerLayer];
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

- (void)updateCurrentPlayer{
    if (currentPlayer != self) {
        [currentPlayer pause];
        currentPlayer = self;
    }
}

- (NSArray<NSString *> *)observeKeys{
    return @[@"rate", @"timeControlStatus"];
}

- (NSArray<NSString *> *)itemObserveKeys{
    return @[
             //监听状态属性
             @"status",
             //监听网络加载情况属性
             @"loadedTimeRanges",
             //监听播放的区域缓存是否为空
             @"playbackBufferEmpty",
             //缓存可以播放的时候调用
             @"playbackLikelyToKeepUp"
             ];
}

- (void)addKVOs{
    AVPlayerItem *playerItem = self.playerItem;
    if (!playerItem) {
        return;
    }
    
    [[self itemObserveKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        [playerItem addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
    }];
    
    [[self observeKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        [self.player addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
    }];
}

- (void)removeKVOs{
    AVPlayerItem *playerItem = self.playerItem;
    
    [[self itemObserveKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        [playerItem removeObserver:self forKeyPath:key];
    }];
    [[self observeKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        [self.player removeObserver:self forKeyPath:key];
    }];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    NSLog(@"key changed %@ %@", keyPath, change);
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus itemStatus = [change[NSKeyValueChangeNewKey] integerValue];
        switch (itemStatus) {
            case AVPlayerItemStatusUnknown: {
                self.status = PNPlayerStatusUnknown;
                break;
            }
            case AVPlayerItemStatusReadyToPlay: {
                self.status = PNPlayerStatusReadyToPlay;
                break;
            }
            case AVPlayerItemStatusFailed: {
                self.status = PNPlayerStatusFailed;
                break;
            }
            default:
                break;
        }
    } else if ([keyPath isEqualToString:@"timeControlStatus"]) {
        AVPlayerTimeControlStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerTimeControlStatusPaused && self.status != PNPlayerStatusCompleted) {
            self.status = PNPlayerStatusPaused;
        }
        if (status == AVPlayerTimeControlStatusPlaying) {
            self.status = PNPlayerStatusPlaying;
        }
        if (status == AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate) {
            self.status = PNPlayerStatusBuffering;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {  //监听播放器的下载进度
        NSInteger timeInterval = [self loadedTime];
        if ([self.delegate respondsToSelector:@selector(player:loadedTimeChanged:)]) {
            [self.delegate player:self loadedTimeChanged:timeInterval];
        }
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) { //监听播放器在缓冲数据的状态
        self.status = PNPlayerStatusBuffering;
    } if ([keyPath isEqualToString:@"rate"]){
        //当rate==0时为暂停,rate==1时为播放,当rate等于负数时为回放
//        if ([change[NSKeyValueChangeNewKey] integerValue] == 0) {
//            self.status = PNPlayerStatusPaused;
//        } else {
//            self.status = PNPlayerStatusPlaying;
//        }
    }
}

- (void)setStatus:(PNPlayerStatus)status{
    if (status != _status) {
        _status = status;
        if ([self.delegate respondsToSelector:@selector(player:statusDidChange:)]) {
            [self.delegate player:self statusDidChange:status];
        }
    }
}

- (void)addTimeObserver{
    __weak __typeof__(self) weakSelf = self;
    _timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.f, 1.f) queue:NULL usingBlock:^(CMTime time) {
        NSInteger seconds = CMTimeGetSeconds(weakSelf.player.currentItem.currentTime);
        if (!CMTIME_IS_INDEFINITE(self.player.currentItem.asset.duration)) {
            if ([weakSelf.delegate respondsToSelector: @selector(player:currentTimeChanged:)]) {
                [weakSelf.delegate player:weakSelf currentTimeChanged:seconds];
            }
        }
    }];
}

- (void)playerDidFinishPlaying:(NSNotification *)notify {
    self.status = PNPlayerStatusCompleted;
}

- (void)removeTimeObserver{
    [_player removeTimeObserver:_timeObserver];
}

- (void)replaceURL:(NSURL *)url{
    AVURLAsset *asset = [[PNAssetManager shared] assetWithURL:url];
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
}

- (void)setPlayerItem:(AVPlayerItem *)playerItem{
    _playerItem = playerItem;
}

- (void)playWithURL:(NSURL *)url{
    [self replaceURL:url];
    [self play];
}

- (void)replay{
    [self seekToTime:kCMTimeZero];
    [self play];
}

- (void)play{
    if (self.status == PNPlayerStatusPlaying) {
        return;
    }
    if (self.playerItem != self.player.currentItem) {
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    }
    
    [self updateCurrentPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self addKVOs];
    [self addTimeObserver];
    [self.player play];
}

- (void)pause{
    if (self.status == PNPlayerStatusPaused || self.status == PNPlayerStatusCompleted) {
        return;
    }
    [self.player pause];
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self removeKVOs];
    [self removeTimeObserver];
}

- (CGFloat)videoWidth{
    return self.playerLayer.videoRect.size.width;
}

- (CGFloat)videoHeight{
    return self.playerLayer.videoRect.size.height;
}

- (NSInteger)totalTime{
    return CMTimeGetSeconds(self.player.currentItem.duration);
}

- (NSInteger)currentTime{
    return CMTimeGetSeconds(self.player.currentItem.currentTime);
}

- (NSInteger)loadedTime{
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];      // 获取缓冲区域
    NSInteger startSeconds = CMTimeGetSeconds(timeRange.start);
    NSInteger durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSInteger result = startSeconds + durationSeconds;
    return result;
}

- (NSString *)currentURL{
    AVAsset *asset = self.player.currentItem.asset;
    if (![asset isKindOfClass:AVURLAsset.class]) return nil;
    return [[(AVURLAsset *)asset URL] absoluteString];
}

- (void)setMuted:(BOOL)shouldMute{
    [self.player setMuted:shouldMute];
}

- (void)seekToTime:(CMTime)time{
    [self.player seekToTime:time];
}

+ (void)pauseCurrent{
    [currentPlayer pause];
}

@end
