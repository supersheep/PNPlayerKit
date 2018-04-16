//
//  PNVideoHeadControl.m
//  PNPlayerKit
//
//  Created by Spud Hsu on 2018/4/15.
//  Copyright © 2018年 Spud Hsu. All rights reserved.
//

#import "PNVideoHeadControl.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@interface PNVideoHeadControl()
@property (nonatomic, strong) UIButton *btnClose;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation PNVideoHeadControl
- (instancetype)init{
    if(self = [super init]){
        [self load];
    }
    return self;
}

- (void)load{
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.layer addSublayer:self.gradientLayer];
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设置颜色数组
    self.gradientLayer.colors = @[(__bridge id)[[UIColor colorWithHex:0x000000] colorWithAlphaComponent:0.25].CGColor,
                                  (__bridge id)[[UIColor colorWithHex:0x000000] colorWithAlphaComponent:0].CGColor];
    //设置颜色分割点（范围：0-1）
    self.gradientLayer.locations = @[@(0.0f), @(1.0f)];
    
    
    self.btnClose = [UIButton new];
    self.btnClose.contentMode = UIViewContentModeCenter;
    [self.btnClose setImage:[UIImage imageNamed:@"share_close_button"] forState:UIControlStateNormal];
    [self addSubview:self.btnClose];
    [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(44);
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(5);
    }];
    [self.btnClose addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeButtonTapped{
    if ([self.delegate respondsToSelector:@selector(videoHeadControlCloseTapped)]) {
        [self.delegate videoHeadControlCloseTapped];
    }
}

- (void)setItems:(NSArray<UIView *> *)items{
    for (int i = 0; i < items.count; i++) {
        UIView *view = items[i];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.right.mas_equalTo(-5);
            } else {
                make.right.equalTo(items[i - 1].mas_left);
            }
            make.top.mas_equalTo(2);
            make.width.height.mas_equalTo(44);
        }];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

@end
