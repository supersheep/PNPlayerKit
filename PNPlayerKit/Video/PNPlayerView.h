//
//  PNPlayerView.h
//  PNPlayerKit
//
//  Created by Spud Hsu on 2018/4/14.
//  Copyright © 2018年 Spud Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PNPlayer.h"

typedef NS_ENUM(NSUInteger, PNPlayerControlType) {
    PNPlayerControlTypeNone,
    PNPlayerControlTypeTiny,
    PNPlayerControlTypeSimple,
    PNPlayerControlTypeFull
};

@class PNPlayerView;
@protocol PNPlayerViewDelegate <NSObject>
- (void)playerViewPlayButtonTapped:(PNPlayerView *)player;
- (void)playerView:(PNPlayerView *)player loadedTimeChanged:(NSInteger)loadedTime;
- (void)playerView:(PNPlayerView *)player currentTimeChanged:(NSInteger)currentTime;
- (void)playerView:(PNPlayerView *)player statusDidChange:(PNPlayerStatus)status;
@end

@interface PNPlayerView : UIView
@property (nonatomic, weak) id<PNPlayerViewDelegate> delegate;
@property (nonatomic, strong) PNPlayer *player;
@property (nonatomic, readonly) NSInteger currentTime;
@property (nonatomic, readonly) NSInteger totalTime;
@property (nonatomic, readonly) CMTimeScale timeScale;
@property (nonatomic, readonly) PNPlayerStatus status;
- (instancetype)initWithControlType:(PNPlayerControlType)type;
- (void)setVideo:(NSString *)video poster:(NSString *)poster;
- (void)play;
- (void)pause;
- (void)seekTo:(CMTime)time;
- (void)mute:(BOOL)shouldMute;
- (CGRect)fullScreenSize;
@end
