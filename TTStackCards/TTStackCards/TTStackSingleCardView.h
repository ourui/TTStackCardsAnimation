//
//  TTStackSingleCardView.h
//  TTStackCards
//
//  Created by wangrui on 15-1-19.
//  Copyright (c) 2015年 wangrui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTStackCards;

@interface TTStackSingleCardView : UIView

@property(nonatomic)CGPoint originPosition;
@property(nonatomic)CGSize originSize;
@property(nonatomic)CGRect originFrame;
@property(nonatomic,weak)TTStackCards *stackCards;
@property(nonatomic)BOOL shouldHandleTouchEvent;
@end
