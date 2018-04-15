//
//  PNVideoControlProtocol.h
//  PNPlayerKit
//
//  Created by Spud Hsu on 2018/4/14.
//  Copyright © 2018年 Spud Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNVideoControlDelegate.h"

@protocol PNVideoControlProtocol <NSObject>
@property (nonatomic, weak) id<PNVideoControlDelegate> delegate;
- (void)setPlayingState:(BOOL)isPlaying;
- (void)setTotalTime:(NSInteger)totalTime;
- (void)setCurrentTime:(NSInteger)currentTime;
- (void)updateProgress:(float)progress;
- (void)reset;
@end
