//
//  TTStackSingleCardView.m
//  TTStackCards
//
//  Created by wangrui on 15-1-19.
//  Copyright (c) 2015年 wangrui. All rights reserved.
//

#import "TTStackSingleCardView.h"
#import "SKBounceAnimation.h"
#import "TTStackCardsPrivate.h"

@interface TTStackSingleCardView ()

@property(nonatomic)CGPoint touchBeginPoint;
@property(nonatomic)CGPoint lastTouchPoint;
@property(nonatomic)NSTimeInterval beginTimeStamp;
@end


CGFloat const TTDisappearDistance = 130.0;

@implementation TTStackSingleCardView

- (CGFloat)distanceFromPoint:(CGPoint)begin toPoint:(CGPoint)end{
    return  sqrt(pow( begin.x - end.x,2) + pow(begin.y - end.y,2));
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if (touch.tapCount == 1 && self.shouldHandleTouchEvent) {
        
        self.beginTimeStamp = touch.timestamp;
        
        self.touchBeginPoint = [touch locationInView:self.superview];
        self.lastTouchPoint = self.touchBeginPoint;
    }

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if (touch.tapCount == 1 && self.shouldHandleTouchEvent) {
        CGPoint curTouchPoint = [touch locationInView:self.superview];
        CGFloat deltaX = curTouchPoint.x - self.lastTouchPoint.x;
        CGFloat deltaY = curTouchPoint.y - self.lastTouchPoint.y;
        CGPoint lastPoint = self.center;
        self.center = CGPointMake(self.center.x + deltaX, self.center.y + deltaY);
        self.lastTouchPoint = curTouchPoint;
        
        [self.stackCards cardMoveFromPositon:lastPoint toPosition:self.center];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
   
    UITouch *touch = [touches anyObject];
    
    if (self.shouldHandleTouchEvent) {
       
        CGFloat distance =  abs(self.originPosition.x - self.center.x);
        if (distance > TTDisappearDistance) {
            [self.stackCards triggerRemoveActionWithTouchTime:(touch.timestamp - self.beginTimeStamp)];
        }
        else {
            [self bouncesToOriginal];
            [self.stackCards scaleDownCardsWithAnimationDuration:0.15];
        }
    }
}


- (void)bouncesToOriginal {
    
    NSTimeInterval totoalTime = 0.35;
    
    UIView * card = self;
    CGFloat moveSpace = [self distanceFromPoint:self.originPosition toPoint:self.center];
    CGFloat animationTime = moveSpace/TTDisappearDistance * totoalTime;
    
    NSString *keyPath = @"position";
    id finalValue = [NSValue valueWithCGPoint:self.originPosition];
    
    SKBounceAnimation *bounceAnimation = [SKBounceAnimation animationWithKeyPath:keyPath];
    bounceAnimation.numberOfBounces = 4;
    bounceAnimation.fromValue = [NSValue valueWithCGPoint:card.center];
    bounceAnimation.toValue = finalValue;
    bounceAnimation.duration = animationTime;
    bounceAnimation.shouldOvershoot = YES;
    
    
    [card.layer addAnimation:bounceAnimation forKey:@"someKey"];
    [card.layer setValue:finalValue forKeyPath:keyPath];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self removeFromSuperview];
}

@end
