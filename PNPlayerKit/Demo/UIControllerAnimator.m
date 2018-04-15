//
//  UIControllerAnimator.m
//  PNPlayerKit
//
//  Created by Spud Hsu on 2018/4/12.
//  Copyright © 2018年 Spud Hsu. All rights reserved.
//

#import "UIControllerAnimator.h"

@interface UIControllerAnimator ()

@end

@implementation UIControllerAnimator

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    [self alphaTransition:transitionContext];
}

- (void)alphaTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
//    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *containerView = transitionContext.containerView;
    [containerView addSubview:toView];
    
    toView.alpha = 0;
    toView.frame = CGRectMake(0, 0, toView.frame.size.width, toView.frame.size.height);
    
    [UIView animateWithDuration:0.5 animations:^{
        toView.alpha = 1;
        toView.frame = CGRectMake(0, 0, toView.frame.size.width, toView.frame.size.height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
}

- (void)transformTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
//    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *containerView = transitionContext.containerView;
    [containerView addSubview:toView];
    
//    fromView.frame = CGRectMake(0, 0, fromView.frame.size.width, fromView.frame.size.height);
    toView.frame = CGRectMake(toView.frame.size.width, 0, toView.frame.size.width, toView.frame.size.height);
    
    [UIView animateWithDuration:0.5 animations:^{
//        fromView.frame = CGRectMake(-fromView.frame.size.width, 0, fromView.frame.size.width, fromView.frame.size.height);
        toView.frame = CGRectMake(0, 0, toView.frame.size.width, toView.frame.size.height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
