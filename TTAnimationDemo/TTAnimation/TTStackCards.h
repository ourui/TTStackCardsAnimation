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

//视图拖动时 factor:(0.0-1.0) 1.0 表示移动到最大程度,释放即将移除
- (void)ttStackCardView:(TTStackSingleCardView *)cardView movingOnDirection:(TTStackCardsDicretion)direction movingFactor:(CGFloat)factor;

//视图已移除
- (void)ttStackCardView:(TTStackSingleCardView *)cardView didRemovedOnDirection:(TTStackCardsDicretion)direction;

@end

@interface TTStackCards : NSObject
@property(nonatomic,weak)id<TTStackCardsDelegate> delegate;

+ (void)setBottomCardFrame:(CGRect)frame;

+ (instancetype)cardsWithPresenedView:(UIView *)superView ttStackCardsDelegate:(id)delegate;

- (void)animationRemoveOnDirecion:(TTStackCardsDicretion)direciton;

@end
