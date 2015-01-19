//
//  TTStackCards.h
//  TanTanAnimation
//
//  Created by wangrui on 15-1-15.
//  Copyright (c) 2015年 wangrui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTStackSingleCardView;

typedef NS_ENUM(NSUInteger, TTStackCardsDicretion) {
    TTStackCardsDicretionLeft = 1,
    TTStackCardsDicretionRight = 2,
    TTStackCardsDicretionUnknow,
};

@protocol TTStackCardsDelegate <NSObject>

- (TTStackSingleCardView *)ttStackCardView;

@optional
- (void)ttStackCard:(UIView *)card didRemoveOnDirection:(TTStackCardsDicretion)direciton;
@end

@interface TTStackCards : NSObject
@property(nonatomic,weak)id<TTStackCardsDelegate> delegate;

+ (void)setBottomCardFrame:(CGRect)frame;

+ (instancetype)cardsWithPresenedInView:(UIView *)superView ttStackCardsDelegate:(id)delegate;

- (void)animationRemoveOnDirecion:(TTStackCardsDicretion)direciton;

@end
