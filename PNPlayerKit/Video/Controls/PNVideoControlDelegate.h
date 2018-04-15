//
//  PNVideoControlDelegate.h
//  PNPlayerKit
//
//  Created by Spud Hsu on 2018/4/14.
//  Copyright © 2018年 Spud Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PNVideoControlDelegate <NSObject>
-(void)videoControlTapPlay;
-(void)videoControlTapPause;
-(void)videoControlMoveProgress:(CGFloat)progress;
-(void)videoControlTransformOrientation:(UIDeviceOrientation)orientation;
@end
