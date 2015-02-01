//
//  TTSChosenViewController.m
//  TanTanAnimation
//
//  Created by wangrui on 15-1-12.
//  Copyright (c) 2015年 wangrui. All rights reserved.
//

#import "ChosenViewController.h"
#import "ChosenCard.h"
#import "TTStackCards.h"


@interface ChosenViewController ()<TTStackCardsDelegate>

@property(nonatomic,strong)TTStackCards *stackCards;
@end



@implementation ChosenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"TanTan";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.stackCards = [TTStackCards cardsWithPresenedView:self.view ttStackCardsDelegate:self];

}

- (UIView *)ttStackCardView {
    
    static int i;
    
    if (i < 6) {
        i++;
        return [ChosenCard newCard];
    }
    
    return nil;
}

- (IBAction)like:(id)sender {
    [self.stackCards animationRemoveOnDirecion:TTStackCardsDicretionRight];
}


- (IBAction)dislike:(id)sender {
    [self.stackCards animationRemoveOnDirecion:TTStackCardsDicretionLeft];
}

- (void)ttStackCardView:(TTStackSingleCardView *)cardView movingOnDirection:(TTStackCardsDicretion)direction movingFactor:(CGFloat)factor {
    NSLog(@"moving:%f",factor);
}

- (void)ttStackCardView:(TTStackSingleCardView *)cardView didRemovedOnDirection:(TTStackCardsDicretion)direction {
    NSLog(@"over");
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
