//
//  AWPopAnimationView.m
//  JALearnOC
//
//  Created by jason on 15/8/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWPopAnimationView.h"

@implementation AWPopAnimationView

-(instancetype)init
{
    
    if(self = [super init]){
        
        [self layoutAllSubviews];
    }
    
    return self;
}


- (void)layoutAllSubviews{
    
    UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
    bgView.userInteractionEnabled = YES;
    [self addSubview:bgView];
    
    // 添加手势事件,移除View
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissContactView:)];
    [bgView addGestureRecognizer:tapGesture];
}


#pragma mark - 手势点击事件,移除View
- (void)dismissContactView:(UITapGestureRecognizer *)tapGesture{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - custom Method
-(void)showMaskedView
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    [UIView transitionWithView:self duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        [window addSubview:self];
        
    } completion:nil];
}


-(void)hideMaskedView
{
    [UIView transitionWithView:self duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        [self removeFromSuperview];
        
    } completion:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
