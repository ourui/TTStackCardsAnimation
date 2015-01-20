//
//  TTStackSingleCardViewProtocal.h
//  TTStackCards
//
//  Created by rui on 1/20/15.
//  Copyright (c) 2015 wangrui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTStackCards.h"

@interface TTStackCards ()

- (void)cardMoveFromPositon:(CGPoint)from toPosition:(CGPoint)to;

- (void)triggerRemoveActionWithTouchTime:(NSTimeInterval)touchTime;

//向下压下动画
- (void)scaleDownCardsWithAnimationDuration:(float)duration;

//向上弹起动画
- (void)scaleUpCardsWithAnimationDuration:(float)duration;

@end
