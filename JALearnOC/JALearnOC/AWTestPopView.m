//
//  AWTestPopView.m
//  JALearnOC
//
//  Created by jason on 15/8/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWTestPopView.h"

@implementation AWTestPopView

-(instancetype)init
{
    if(self = [super init]){
        
        self.frame = [UIScreen mainScreen].bounds;
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - 初始化子控件
- (void)initSubviews
{
    
    UIView *contentBgView = [UIView new];
    contentBgView.backgroundColor = [UIColor whiteColor];
    contentBgView.userInteractionEnabled = YES;
    [self addSubview:contentBgView];
    
    [contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(267,300));
    }];
    
    _sureBtn = [UIButton new];
    _sureBtn.backgroundColor = [UIColor redColor];
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [contentBgView addSubview:_sureBtn];
    
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(contentBgView);
        make.size.mas_equalTo(CGSizeMake(200,45));
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
