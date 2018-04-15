//
//  PNPlayer.h
//  PNPlayerKit
//
//  Created by Spud Hsu on 2018/4/14.
//  Copyright © 2018年 Spud Hsu. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "PNPlayerOrientation.h"

typedef enum : NSUInteger {
    PNPlayerStatusUnknown = 1,
    PNPlayerStatusBuffering,
    PNPlayerStatusReadyToPlay,
    PNPlayerStatusPlaying,
    PNPlayerStatusPaused,
    PNPlayerStatusFailed,
    PNPlayerStatusCompleted
} PNPlayerStatus;

@class PNPlayer;
@protocol PNPlayerDelegate <NSObject>
- (void)player:(PNPlayer *)player loadedTimeChanged:(NSInteger)loadedTime;
- (void)player:(PNPlayer *)player currentTimeChanged:(NSInteger)currentTime;
- (void)player:(PNPlayer *)player statusDidChange:(PNPlayerStatus)status;
@end

@interface PNPlayer : UIView
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) PNPlayerStatus status;
@property (nonatomic, assign) PNPlayerOrientation orientation;

@property (nonatomic, readonly) NSInteger currentTime;
@property (nonatomic, readonly) NSInteger loadedTime;
@property (nonatomic, readonly) NSInteger totalTime;
@property (nonatomic, readonly) CGFloat videoWidth;
@property (nonatomic, readonly) CGFloat videoHeight;
@property (nonatomic, readonly) NSString *currentURL;
@property (nonatomic, weak) id<PNPlayerDelegate> delegate;
- (void)replaceURL:(NSURL *)url;
- (void)playWithURL:(NSURL *)url;
- (void)play;
- (void)pause;
- (void)replay;
- (void)setMuted:(BOOL)shouldMute;
- (void)seekToTime:(CMTime)time;
//+ (PLPlayerOption *)defaultOption;
+ (void)pauseCurrent;
@end

