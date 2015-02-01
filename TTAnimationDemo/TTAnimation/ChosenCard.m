//
//  TTSChosenCard.m
//  TanTanAnimation
//
//  Created by wangrui on 15-1-12.
//  Copyright (c) 2015年 wangrui. All rights reserved.
//

#import "ChosenCard.h"

@implementation ChosenCard

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 10;
        self.layer.borderColor = [UIColor colorWithRed:170.0/255 green:170.0/255 blue:170.0/255 alpha:1.0].CGColor;
        self.layer.borderWidth = 1.0;
        
        self.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0];
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 50)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%d",arc4random() % 10];
        [self addSubview:label]; 
    }
    
    return self;
}


+ (instancetype)newCard {
    return [[ChosenCard alloc]initWithFrame:CGRectMake(0, 0, 240, 310)];
}


@end
