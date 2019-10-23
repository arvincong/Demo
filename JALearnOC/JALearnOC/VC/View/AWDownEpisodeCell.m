//
//  AWDownEpisodeCell.m
//  JALearnOC
//
//  Created by jason on 24/7/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWDownEpisodeCell.h"

@implementation AWDownEpisodeCell

-(instancetype)initWithFrame:(CGRect)frame
{
    
    if(self = [super initWithFrame:frame]){
        
        _episodeBtn = [UIButton new];
        _episodeBtn.enabled = NO;
        _episodeBtn.layer.masksToBounds = YES;
        _episodeBtn.layer.borderWidth = 1;
        _episodeBtn.layer.borderColor = [UIColor colorWithHexString:@"#6e6f71"].CGColor;
        [_episodeBtn setTitleColor:[UIColor colorWithHexString:@"#6e6f71"] forState:UIControlStateNormal];
        _episodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _episodeBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_episodeBtn];
        
        [_episodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    return self;
}

@end
