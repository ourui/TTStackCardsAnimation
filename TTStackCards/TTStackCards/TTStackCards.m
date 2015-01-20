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
@property(nonatomic)TTStackCardsDicretion curDirection;
@property(nonatomic,strong)NSMutableArray *cardsToRemove;



@end

static CGRect bottomCardFrame = {0,0,0,0};
static CGPoint originPoints[4];
static CGRect originFrames[4];
static CGFloat recusiveSpace = 22;
static CGFloat recusiveScale = 1.05;

@implementation TTStackCards

+ (void)setBottomCardFrame:(CGRect)frame {
    bottomCardFrame = frame;
}

+ (instancetype)cardsWithPresenedInView:(UIView *)superView ttStackCardsDelegate:(id)delegate{
    
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
        self.cardsToRemove = [NSMutableArray array];
        self.superView = superView;
        self.delegate = dele;
        
        NSAssert(1,@"delt");
        
        for (int i=0; i<4; i++) {
            TTStackSingleCardView *newCard = [self.delegate ttStackCardView];
            newCard.top = 135;
            
            if (i>1) {
                newCard.width =  newCard.width *  pow(recusiveScale, i-1);
                newCard.height =  newCard.height *  pow(recusiveScale, i-1);
                newCard.top = 135 - (i-1) * recusiveSpace;
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
//    [self scaleUpCardsWithDuration:1.0];
}

- (void)triggerRemoveAction {
    
}

- (void)moveOffOnDirection:(TTStackCardsDicretion)direction {
   
    UIView * card = [self.cards firstObject];
    
    CGPoint dsc;
    
    if (direction == TTStackCardsDicretionLeft) {
        dsc = CGPointMake(card.centerX + self.superView.width/2, card.centerY);
    }
    
    if (direction == TTStackCardsDicretionRight) {
        dsc = CGPointMake(card.centerX - self.superView.width/2, card.centerY);
    }
    
    UIView *cardToRm = [self removeTopCard];
    [self.cardsToRemove removeObject:cardToRm];
    
    [UIView animateWithDuration:0.25 animations:^{
        card.center = dsc;
    } completion:^(BOOL finished) {
        
        [card removeFromSuperview];
    }];
    
    [self scaleUpCardsWithDuration:0.30];
}

- (void)scaleDownCardsWithAnimation {
    for (int i=1; i<=2; i++) {
        [UIView animateWithDuration:0.15 animations:^{
            UIView *card = self.cards[i];
            card.frame = originFrames[i];
        }];
    }
}

- (void)scaleUpCardsWithDuration:(float)duration {
    for (int i=0; i<=1; i++) {
        [UIView animateWithDuration:duration animations:^{
            UIView *card = self.cards[i];
            card.frame = originFrames[i];
        }];
    }
}

- (id)removeTopCard {
    id first = [self.cards dequeue];
    UIView *bottom = [self.cards lastObject];
    UIView *newCard = (UIView *)[self.delegate ttStackCardView];
  
    newCard.center = bottom.center;
    [self.cards enqueue:newCard];
    [self.superView insertSubview:newCard belowSubview:bottom];
   
    [self.cardsToRemove addObject:first];
    
    return first;
}

- (void)like:(id)sender {
    self.curDirection = TTStackCardsDicretionRight;
    UIView *first = [self removeTopCard];
    
    CAAnimation *animation = sender ? [self backOutAnimationOnDirection:TTStackCardsDicretionRight]:
    [self simpleMoveOutAnimationOnDirection:TTStackCardsDicretionRight];
    
    [first.layer addAnimation:animation forKey:@"disappear"];
    
    [self scaleUpCardsWithDuration:sender? 0.15:0.0];
}


- (void)dislike:(id)sender {
    self.curDirection = TTStackCardsDicretionLeft;
    UIView * first = [self removeTopCard];
    
    CAAnimation *animation = sender ? [self backOutAnimationOnDirection:TTStackCardsDicretionLeft]:
    [self simpleMoveOutAnimationOnDirection:TTStackCardsDicretionLeft];
    
    [first.layer addAnimation:animation forKey:@"disappear"];
    
    [self scaleUpCardsWithDuration:sender? 0.15:0.0];
}


- (CAAnimation *)simpleMoveOutAnimationOnDirection:(NSUInteger)direction {
    CABasicAnimation *disappear = [CABasicAnimation animationWithKeyPath:@"position"];
    
    disappear.fromValue = [NSValue valueWithCGPoint:originPoints[0]];
    
    CGPoint dsc;
    
    if (direction == TTStackCardsDicretionRight) {
        dsc = CGPointMake(self.superView.width / 2 * 3, originPoints[0].y + 80);
    }
    
    if (direction == TTStackCardsDicretionLeft) {
        dsc = CGPointMake(- self.superView.width/2, originPoints[0].y + 80);
    }
    
    disappear.toValue = [NSValue valueWithCGPoint:dsc];
    disappear.duration = 0.18;
    disappear.delegate = self;
    
    return disappear;
}

- (CAAnimation *)backOutAnimationOnDirection:(NSUInteger)direction {
    CGPoint pointsR[3] = {
        CGPointMake(originPoints[0].x - 5, originPoints[0].y),
        originPoints[0],
        CGPointMake(self.superView.width + 150, originPoints[0].y + 50)
    };
    
    CGPoint pointsL[3] = {
        CGPointMake(originPoints[0].x + 5, originPoints[0].y),
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
    rotate.toValue = @((direction==1? -1.0:1.0)*5.0 / 180 * M_PI);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation,rotate];
    group.delegate = self;
    group.duration = 0.55;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return group;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    for (UIView *card in self.cardsToRemove) {
      
        [card removeFromSuperview];
    }
    
    [self.cardsToRemove removeAllObjects];
}

- (void)animationRemoveOnDirecion:(TTStackCardsDicretion)direciton {
    if (direciton == TTStackCardsDicretionLeft) {
        [self dislike:@""];
    }
    else if(direciton == TTStackCardsDicretionRight){
        [self like:@""];
    }
}

@end
