//
//  PNAssetManager.h
//  PNPlayerKit
//
//  Created by Spud Hsu on 2018/4/14.
//  Copyright © 2018年 Spud Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface PNAssetManager : NSObject
+ (instancetype)shared;
- (AVURLAsset *)assetWithURL:(NSURL *)url;
@end
