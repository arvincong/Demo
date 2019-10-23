//
//  AWDramaCell.m
//  JALearnOC
//
//  Created by jason on 12/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWDramaCell.h"

@implementation AWDramaCell

-(instancetype)initWithFrame:(CGRect)frame
{
    
    if(self = [super initWithFrame:frame]){
        
        _coverImageView = [UIImageView new];
        //_coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_coverImageView];
        
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top);
            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTHL -40)/3,150));
        }];
        
        _videoTitleLabel = [UILabel new];
        _videoTitleLabel.font = [UIFont systemFontOfSize:15];
        _videoTitleLabel.textColor = [UIColor whiteColor];
        _videoTitleLabel.numberOfLines = 0;
        _videoTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_videoTitleLabel];
        
        [_videoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.coverImageView);
            make.top.equalTo(self.coverImageView.mas_bottom).offset(10);
        }];
        
    }
    
    return self;
}
@end
