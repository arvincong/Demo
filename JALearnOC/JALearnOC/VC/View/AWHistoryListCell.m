//
//  AWHistoryListCell.m
//  JALearnOC
//
//  Created by jason on 14/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWHistoryListCell.h"

@implementation AWHistoryListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        _videoImageView = [UIImageView new];
        [self.contentView addSubview:_videoImageView];
        
        [_videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(15);
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTHL -40)/3,150));
        }];
        
        _videoTitleLabel = [UILabel new];
        _videoTitleLabel.font = [UIFont systemFontOfSize:15];
        _videoTitleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_videoTitleLabel];
        
        [_videoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.videoImageView.mas_right).offset(10);
            make.top.equalTo(self.videoImageView.mas_centerY).offset(-20);
            make.height.mas_equalTo(16);
        }];
        
        _videoRecordLabel = [UILabel new];
        _videoRecordLabel.font = [UIFont systemFontOfSize:15];
        _videoRecordLabel.textColor = [UIColor colorWithHexString:@"#00c6ff"];
        [self.contentView addSubview:_videoRecordLabel];
        
        [_videoRecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.videoTitleLabel.mas_left);
            make.top.equalTo(self.videoTitleLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(15);
        }];
    }
    
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
