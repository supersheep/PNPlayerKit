//
//  PNVideoControlTiny.h
//  PNPlayerKit
//
//  Created by Spud Hsu on 2018/4/14.
//  Copyright © 2018年 Spud Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNVideoControlProtocol.h"

@interface PNVideoControlTiny : UIView <PNVideoControlProtocol>
@property (nonatomic, weak) id<PNVideoControlDelegate> delegate;
@end
