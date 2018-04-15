//
//  PNVideoControlDelegate.h
//  PNPlayerKit
//
//  Created by Spud Hsu on 2018/4/14.
//  Copyright © 2018年 Spud Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNPlayerOrientation.h"

@protocol PNVideoControlDelegate <NSObject>
@optional
-(void)videoControlTapPlay;
-(void)videoControlTapPause;
-(void)videoControlTapTransform;
-(void)videoControlMoveProgress:(CGFloat)progress;
-(void)videoControlTransformOrientation:(PNPlayerOrientation)orientation;
@end
