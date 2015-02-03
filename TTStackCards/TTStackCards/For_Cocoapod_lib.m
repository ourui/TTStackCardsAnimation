//
//  For_Cocoapod_lib.m
//  TTStackCards
//
//  Created by wangrui on 15-2-3.
//  Copyright (c) 2015年 wangrui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTStackCards.h"
#import "TTStackSingleCardView.h"

@interface For_Cocoapod_lib : NSObject

@end

@implementation For_Cocoapod_lib

+ (void)load {
    [TTStackSingleCardView description];
    [TTStackCards description];
}

@end
