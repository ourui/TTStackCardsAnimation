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

- (NSInteger)numberOfCardsEstimated;

- (TTStackSingleCardView *)ttStackCardView;

@optional

/**
 *  @brief  拖动Card时的回调
 *
 *  @param cardView
 *  @param direction
 *  @param factor    0.0-1.0
 */
- (void)ttStackCardView:(TTStackSingleCardView *)cardView
      movingOnDirection:(TTStackCardsDicretion)direction
           movingFactor:(CGFloat)factor;

/**
 *  @brief  Card移除时的回调
 *
 *  @param cardView
 *  @param direction
 */
- (void)ttStackCardView:(TTStackSingleCardView *)cardView
  didRemovedOnDirection:(TTStackCardsDicretion)direction;

@end

@interface TTStackCards : NSObject
@property(nonatomic,weak)id<TTStackCardsDelegate> delegate;

+ (void)setBottomCardFrame:(CGRect)frame;

+ (instancetype)cardsWithPresenedView:(UIView *)superView ttStackCardsDelegate:(id)delegate;

- (void)animationRemoveOnDirecion:(TTStackCardsDicretion)direciton;

@end
