//
//  TTStackSingleCardView.m
//  TTStackCards
//
//  Created by wangrui on 15-1-19.
//  Copyright (c) 2015年 wangrui. All rights reserved.
//

#import "TTStackSingleCardView.h"

@interface TTStackSingleCardView ()

@property(nonatomic)CGPoint touchBeginPoint;
@property(nonatomic)CGPoint lastTouchPoint;
@end


CGFloat const TTDisappearDistance = 50;

@implementation TTStackSingleCardView

- (CGFloat)distanceFromPoint:(CGPoint)begin toPoint:(CGPoint)end{
    return  sqrt(pow( begin.x - end.x,2) + pow(begin.y - end.y,2));
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if (touch.tapCount == 1 && self.shouldHandleTouchEvent) {
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
        self.center = CGPointMake(self.center.x + deltaX, self.center.y + deltaY);
        self.lastTouchPoint = curTouchPoint;
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if (touch.tapCount == 1 && self.shouldHandleTouchEvent) {
       
        if ([self distanceFromPoint:self.originPosition toPoint:self.center] > TTDisappearDistance) {
            [self removeFromSuperview];
        }
    }
}

@end
