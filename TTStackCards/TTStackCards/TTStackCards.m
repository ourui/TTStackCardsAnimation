//
//  TTStackCards.m
//  TanTanAnimation
//
//  Created by wangrui on 15-1-15.
//  Copyright (c) 2015年 wangrui. All rights reserved.
//

#import "TTStackCards.h"
#import "UIView+GeometryAddition.h"
#import "TTStackSingleCardView.h"
#import "SKBounceAnimation.h"

@interface NSMutableArray (queue)

- (void)enqueue:(id)obj;
- (id)dequeue;

@end


@implementation NSMutableArray (queue)

- (void)enqueue:(id)obj {
    [self insertObject:obj atIndex:self.count];
}

- (id)dequeue {
    id obj = [self objectAtIndex:0];
    [self removeObjectAtIndex:0];
    return obj;
}

@end



@interface TTStackCards ()

@property(nonatomic,weak)UIView *superView;
@property(nonatomic,strong)NSMutableArray *cards;

@end

static CGRect bottomCardFrame = {0,0,0,0};
static CGPoint originPoints[4];
static CGRect originFrames[4];
static CGFloat recusiveSpace = 22;
static CGFloat recusiveScale = 1.05;
extern CGFloat const TTDisappearDistance;

@implementation TTStackCards

+ (void)setBottomCardFrame:(CGRect)frame {
    bottomCardFrame = frame;
}

+ (instancetype)cardsWithPresenedView:(UIView *)superView ttStackCardsDelegate:(id)delegate{
    
    if (CGRectEqualToRect(bottomCardFrame, CGRectZero)) {
        
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 310)];
        tempView.centerX = superView.width/2;
        tempView.top = 135;
        
        bottomCardFrame = tempView.frame;
    }
    
    return [[self alloc] initWithSuperView:superView delegate:delegate];
}

- (void)enableTouchOnTopCard {
    TTStackSingleCardView *card = [self.cards objectAtIndex:0];
    card.shouldHandleTouchEvent = YES;
}

- (id)initWithSuperView:(UIView *)superView delegate:(id)dele{
    if ((self = [super init])) {
        
        self.cards = [NSMutableArray array];
        self.superView = superView;
        self.delegate = dele;
     
        for (int i=0; i<4; i++) {
            TTStackSingleCardView *newCard = [self.delegate ttStackCardView];
            
            if (!newCard) {
                continue;
            }
            else {
                NSAssert([newCard isKindOfClass:TTStackSingleCardView.class], @"必须要为 TTStackSingleCardView 子类");
            }
            
            newCard.top = bottomCardFrame.origin.y;
            
            if (i>1) {
                newCard.width =  newCard.width *  pow(recusiveScale, i-1);
                newCard.height =  newCard.height *  pow(recusiveScale, i-1);
                newCard.top = bottomCardFrame.origin.y - (i-1) * recusiveSpace;
            }
            
            newCard.centerX = superView.width/2;
            [self.cards insertObject:newCard atIndex:0];
            
            newCard.originFrame = newCard.frame;
            newCard.originPosition = newCard.center;
            newCard.originSize = newCard.bounds.size;
            newCard.stackCards = self;
            
            originPoints[3-i] = newCard.center;
            originFrames[3-i] = newCard.frame;
            
            [superView addSubview:newCard];
        }
        
        [self enableTouchOnTopCard];
    }
    return self;
}

- (void)cardMoveFromPositon:(CGPoint)from toPosition:(CGPoint)to {
    
    TTStackSingleCardView *card = [self.cards objectAtIndex:0];

    TTStackCardsDicretion direction = card.center.x > card.originPosition.x ?
                                    TTStackCardsDicretionRight:TTStackCardsDicretionLeft;
    
    CGFloat distance = abs(card.originPosition.x - to.x);
    CGFloat progress = distance / TTDisappearDistance;
    if (progress > 1.0) {
        progress = 1.0;
    }
    
    for (int i=1; i<=2; i++) {
        TTStackSingleCardView *card = self.cards[i];
        CGRect frame = originFrames[i];
        CGFloat scale = (1.0 + (recusiveScale - 1) * progress);
        
        frame = CGRectMake(frame.origin.x,
                           frame.origin.y - recusiveSpace * progress,
                           frame.size.width * scale,
                           frame.size.height * scale);
        card.frame = frame;
        card.centerX = originPoints[i].x;
    }
    
    if ([self.delegate respondsToSelector:@selector(ttStackCardView:movingOnDirection:movingFactor:)]) {
        [self.delegate ttStackCardView:card movingOnDirection:direction movingFactor:progress];
    }
}

- (void)triggerRemoveActionWithTouchTime:(NSTimeInterval)touchTime{
    
    if (touchTime > 0.25) {
        touchTime = 0.25;
    }
    
    TTStackSingleCardView *card = [self.cards objectAtIndex:0];
    
    TTStackCardsDicretion direction = card.center.x > card.originPosition.x ?
                                      TTStackCardsDicretionRight:TTStackCardsDicretionLeft;
    
    CGPoint disappearPosition;
    
    if (direction == TTStackCardsDicretionLeft) {
        disappearPosition = CGPointMake(-card.width/2, card.centerY);
    }
    else {
        disappearPosition = CGPointMake(self.superView.width+card.width/2, card.centerY);
    }
    
    if ([self.delegate respondsToSelector:@selector(ttStackCardView:movingOnDirection:movingFactor:)]) {
        [self.delegate ttStackCardView:card movingOnDirection:direction movingFactor:1.0];
    }
    
    [UIView animateWithDuration:touchTime animations:^{
        card.center = disappearPosition;
        
    } completion:^(BOOL finished) {
        [self removeTopCard];
        [card removeFromSuperview];
        
        if([self.delegate respondsToSelector:@selector(ttStackCardView:didRemovedOnDirection:)]) {
            [self.delegate ttStackCardView:card didRemovedOnDirection:direction];
        }
        
        [self scaleUpCardsWithAnimationDuration:0.05];
    }];
}

- (id)removeTopCard {
    id first = [self.cards dequeue];
    
    UIView *bottom = [self.cards lastObject];
    TTStackSingleCardView *newCard = [self.delegate ttStackCardView];
  
    if (newCard) {
         NSAssert([newCard isKindOfClass:TTStackSingleCardView.class], @"必须要为 TTStackSingleCardView 子类");
    }
    
    newCard.center = bottom.center;
    [self.cards enqueue:newCard];
    [self.superView insertSubview:newCard belowSubview:bottom];
    
    newCard.originFrame = newCard.frame;
    newCard.originPosition = newCard.center;
    newCard.originSize = newCard.bounds.size;
    newCard.stackCards = self;
   
    [self enableTouchOnTopCard];
    
    return first;
}

- (void)scaleDownCardsWithAnimationDuration:(float)duration {
    for (int i=1; i<=2; i++) {
        [UIView animateWithDuration:duration animations:^{
            TTStackSingleCardView *card = self.cards[i];
            card.frame = originFrames[i];
            card.originFrame = card.frame;
            card.originPosition = card.center;
            card.originSize = card.bounds.size;
        }];
    }
}

- (void)scaleUpCardsWithAnimationDuration:(float)duration {
    for (int i=0; i<=1; i++) {
        [UIView animateWithDuration:duration animations:^{
            TTStackSingleCardView *card = self.cards[i];
            card.frame = originFrames[i];
            card.originFrame = card.frame;
            card.originPosition = card.center;
            card.originSize = card.bounds.size;
        }];
    }
}

#pragma mark - Quick Remove

- (CAAnimation *)backOutAnimationOnDirection:(NSUInteger)direction {
    CGPoint pointsR[3] = {
        CGPointMake(originPoints[0].x - 3, originPoints[0].y),
        originPoints[0],
        CGPointMake(self.superView.width + 150, originPoints[0].y + 50)
    };
    
    CGPoint pointsL[3] = {
        CGPointMake(originPoints[0].x + 3, originPoints[0].y),
        originPoints[0],
        CGPointMake(0 - 150, originPoints[0].y + 50)
    };
    
    CGPoint *ps = direction==1? pointsL:pointsR;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddLines(path, NULL, ps, 3);
    animation.path = path;
    CGPathRelease(path);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.fromValue = @(0);
    rotate.toValue = @((direction==1? -1.0:1.0)*3.0 / 180 * M_PI);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation,rotate];
    group.duration = 0.55;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return group;
}


- (void)animationRemoveOnDirecion:(TTStackCardsDicretion)direciton {
    
    TTStackSingleCardView *cardToRemove = [self removeTopCard];
    
    CAAnimation *animation = [self backOutAnimationOnDirection:direciton];
    animation.delegate = cardToRemove;
    [cardToRemove.layer addAnimation:animation forKey:@"disappear"];
    
    
    if ([self.delegate respondsToSelector:@selector(ttStackCardView:movingOnDirection:movingFactor:)]) {
        [self.delegate ttStackCardView:cardToRemove movingOnDirection:direciton movingFactor:1.0];
    }
    
    if([self.delegate respondsToSelector:@selector(ttStackCardView:didRemovedOnDirection:)]) {
        [self.delegate ttStackCardView:cardToRemove didRemovedOnDirection:direciton];
    }
    
    [self scaleUpCardsWithAnimationDuration:0.45];
}

@end
