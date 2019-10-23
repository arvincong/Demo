//
//  AWDownLoadListCell.m
//  JALearnOC
//
//  Created by jason on 23/7/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWDownLoadListCell.h"

@implementation AWDownLoadListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.contentView.mas_top).offset(15);
            make.height.mas_equalTo(16);
        }];
        
        
        _progressView = [UIProgressView new];
        _progressView.tintColor = [UIColor lightGrayColor];
        _progressView.trackTintColor = [UIColor whiteColor];
        [self.contentView addSubview:_progressView];
        
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(200,10));
        }];
        
        _progressLabel = [UILabel new];
        _progressLabel.font = [UIFont systemFontOfSize:12];
        _progressLabel.textColor = [UIColor whiteColor];
        _progressLabel.text = @"0%";
        [self.contentView addSubview:_progressLabel];
        
        [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.progressView.mas_right).offset(10);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
            make.height.mas_equalTo(15);
        }];
        
        _statusBtn = [UIButton new];
        _statusBtn.layer.masksToBounds = YES;
        _statusBtn.layer.borderWidth = 1;
        _statusBtn.layer.borderColor = [[UIColor colorWithHexString:@"#00c6ff"] CGColor];
        [_statusBtn setTitleColor:[UIColor colorWithHexString:@"#00c6ff"] forState:UIControlStateNormal];
        [_statusBtn setTitle:@"暂停" forState:UIControlStateNormal];
        _statusBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _statusBtn.hidden = YES;
        [self.contentView addSubview:_statusBtn];
        
        [_statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(60,30));
        }];
    }
    
    return self;
}

//处理相关数据
-(void)setLoadItem:(AWDownloadItem *)loadItem
{
    _loadItem = loadItem;
    
    _nameLabel.text = loadItem.customCacheName;
    
    __weak typeof(self) weakSelf = self;
    
    _progressLabel.text = [NSString stringWithFormat:@"%d%%",(int)(loadItem.progress *100)];;
    
    loadItem.AWDownloadProgressBlock = ^(CGFloat progress) {
      
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.progressView.progress = progress;
            weakSelf.progressLabel.text = [NSString stringWithFormat:@"%d%%",(int)(progress *100)];
        });
    };
    
    loadItem.AWDownloadCompletionHandler = ^(NSError * _Nonnull error) {
        if(error == nil){
            weakSelf.progressLabel.text = @"100%";
        }
    };
    
    
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
