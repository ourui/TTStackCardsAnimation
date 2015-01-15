//
//  TTSChosenViewController.m
//  TanTanAnimation
//
//  Created by wangrui on 15-1-12.
//  Copyright (c) 2015年 wangrui. All rights reserved.
//

#import "TTSChosenViewController.h"
#import "TTSChosenCard.h"
#import "TTStackCards.h"


@interface TTSChosenViewController ()<TTStackCardsDelegate>

@property(nonatomic,strong)TTStackCards *stackCards;
@end



@implementation TTSChosenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"TanTan";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.stackCards = [TTStackCards cardsWithPresenedInView:self.view ttStackCardsDelegate:self];

}

- (UIView *)ttStackCardView {
    return [TTSChosenCard newCard];
}

- (IBAction)like:(id)sender {
    [self.stackCards animationRemoveOnDirecion:TTStackCardsDicretionRight];
}


- (IBAction)dislike:(id)sender {
    [self.stackCards animationRemoveOnDirecion:TTStackCardsDicretionLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
