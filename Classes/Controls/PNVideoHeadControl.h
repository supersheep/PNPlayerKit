//
//  PNVideoHeadControl.h
//  PNPlayerKit
//
//  Created by Spud Hsu on 2018/4/15.
//  Copyright © 2018年 Spud Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PNVideoHeadControlDelegate <NSObject>
- (void)videoHeadControlCloseTapped;
@end

@interface PNVideoHeadControl : UIView
@property (nonatomic, weak) id<PNVideoHeadControlDelegate> delegate;
- (void)setItems:(NSArray<UIView *> *)items;
@end
