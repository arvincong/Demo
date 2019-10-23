//
//  AWPlayerListCell.m
//  JALearnOC
//
//  Created by jason on 8/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWPlayerListCell.h"
#import "AWVideoDetailVC.h"

@implementation AWPlayerListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        _videoImageView = [UIImageView new];
        [self.contentView addSubview:_videoImageView];
        
        [_videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(15);
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake(100,120));
        }];
        
        _videoTitleLabel = [UILabel new];
        _videoTitleLabel.font = [UIFont systemFontOfSize:15];
        _videoTitleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_videoTitleLabel];
        
        [_videoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.videoImageView.mas_right).offset(10);
            make.top.equalTo(self.videoImageView.mas_top).offset(25);
            make.height.mas_equalTo(16);
        }];
        
        _videoListBtn = [UIButton new];
        _videoListBtn.layer.masksToBounds = YES;
        _videoListBtn.layer.cornerRadius = 15;
        _videoListBtn.layer.borderWidth = 1;
        _videoListBtn.layer.borderColor = [UIColor colorWithHexString:@"#00c6ff"].CGColor;
        _videoListBtn.backgroundColor = [UIColor clearColor];
        [_videoListBtn setTitleColor:[UIColor colorWithHexString:@"#00c6ff"] forState:UIControlStateNormal];
        _videoListBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_videoListBtn];
        
        [_videoListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.videoTitleLabel.mas_left);
            make.top.equalTo(self.videoTitleLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(80,30));
        }];
        
        _videoContentView = [UIView new];
        _videoContentView.hidden = NO;
        _videoContentView.backgroundColor = [UIColor colorWithHexString:@"#29292e"];
        [self.contentView addSubview:_videoContentView];
        
        [_videoContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.videoImageView.mas_bottom).offset(5);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        
    }
    
    return self;
}

//改变按钮选中颜色
-(void)changeBtnColorMethod:(id)originalBtn
{
    UIButton *currentBtn = (UIButton *)originalBtn;
    
    for (UIButton *btn in self.videoContentView.subviews) {
        if([btn isEqual:currentBtn]){
            btn.layer.borderColor = [UIColor colorWithHexString:@"#00c6ff"].CGColor;
            [btn setTitleColor:[UIColor colorWithHexString:@"#00c6ff"] forState:UIControlStateNormal];
        }else{
            btn.layer.borderColor = [UIColor colorWithHexString:@"#6e6f71"].CGColor;
            [btn setTitleColor:[UIColor colorWithHexString:@"#6e6f71"] forState:UIControlStateNormal];
        }
    }
}

-(void)fillVideoContentViewMethod:(AWVideoListModel *)listModel withOriginalVC:(UIViewController *)originalVC
{
    for (UIButton *btn in _videoContentView.subviews) {
        
        if([btn isKindOfClass:[UIButton class]]){
            
            [btn removeFromSuperview];
        }
    }
    
    __block UIButton *lastBtn = nil;
    
    __weak typeof(self) weakSelf = self;
    
    CGFloat originalWidth = (SCREEN_WIDTHL - 15*6)/5;
    
    [listModel.detailArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AWVideoDetailModel *model = (AWVideoDetailModel *)obj;
        
        UIButton *currentBtn = [UIButton new];
        currentBtn.layer.masksToBounds = YES;
        currentBtn.layer.borderWidth = 1;
        currentBtn.layer.borderColor = [UIColor colorWithHexString:@"#6e6f71"].CGColor;
       //#00c6ff
        [currentBtn setTitle:[NSString stringWithFormat:@"第%ld集",(long)(idx + 1)] forState:UIControlStateNormal];
        [currentBtn setTitleColor:[UIColor colorWithHexString:@"#6e6f71"] forState:UIControlStateNormal];
        currentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        currentBtn.backgroundColor = [UIColor clearColor];
        [self.videoContentView addSubview:currentBtn];
        
        [currentBtn addAction:^(id  _Nonnull sender) {
            [weakSelf changeBtnColorMethod:sender];
            [weakSelf getVideoPlayerUrlMethod:[NSString stringWithFormat:@"%@-%@",listModel.title,model.name] url:model.url withTargetVC:originalVC];
        }];
        
        [currentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(lastBtn){
                if(idx % 5 == 0){
                make.left.equalTo(self.videoContentView.mas_left).offset(15);
                    make.top.equalTo(lastBtn.mas_bottom).offset(15);
                }else{
                    make.left.equalTo(lastBtn.mas_right).offset(15);
                    make.top.equalTo(lastBtn.mas_top);
                }
            }else{
                make.top.equalTo(self.videoContentView.mas_top).offset(15);
                make.left.equalTo(self.videoContentView.mas_left).offset(15);
            }
            make.size.mas_equalTo(CGSizeMake(originalWidth,30));
        }];
        
        
        lastBtn = currentBtn;
    }];
}

-(void)fillVideoViewMethod:(AWVideoModel *)model withOriginalVC:(UIViewController *)originalVC
{
    
    for (UIButton *btn in self.contentView.subviews) {
        
        if([btn isKindOfClass:[UIButton class]]){
            
            [btn removeFromSuperview];
        }
    }
    
    __block UIButton *lastBtn = nil;
    
    __weak typeof(self) weakSelf = self;
    
    CGFloat originalWidth = (SCREEN_WIDTHL - 15*6)/5;
    
    [model.url_list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *currentBtn = [UIButton new];
        currentBtn.layer.masksToBounds = YES;
        currentBtn.layer.borderWidth = 1;
        currentBtn.layer.borderColor = [UIColor colorWithHexString:@"#f2f2f2"].CGColor;
        [currentBtn setTitle:[NSString stringWithFormat:@"第%ld集",idx + 1] forState:UIControlStateNormal];
        [currentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        currentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        currentBtn.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:currentBtn];
        
        [currentBtn addAction:^(id  _Nonnull sender) {
            
            [weakSelf jumpDetailMethod:model.title url:obj withTargetVC:originalVC];
        }];
        
        [currentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(lastBtn){
                if(idx % 5 == 0){
                    make.left.equalTo(self.contentView.mas_left).offset(15);
                    make.top.equalTo(lastBtn.mas_bottom).offset(15);
                }else{
                    make.left.equalTo(lastBtn.mas_right).offset(15);
                    make.top.equalTo(lastBtn.mas_top);
                }
            }else{
                make.top.equalTo(self.videoTitleLabel.mas_bottom).offset(15);
                make.left.equalTo(self.contentView.mas_left).offset(15);
            }
            make.size.mas_equalTo(CGSizeMake(originalWidth,30));
        }];
        
        
        lastBtn = currentBtn;
    }];
}

//获取视频播放地址
-(void)getVideoPlayerUrlMethod:(NSString *)videoName url:(NSString *)originalUrl withTargetVC:(UIViewController *)targetVC
{
    [SVProgressHUD showLoadingHUDInWindow:@"准备中..."];
    
    [[AWNetworkManager sharedInstance] getWithURLString:[NSString stringWithFormat:@"%@%@",MLGB_API_URL,VIDEO_PLAYURL_API] parameters:@{@"url":originalUrl} success:^(id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        
        if([responseObject[@"code"] integerValue] == 0){
            
            AWVideoDetailVC *vc = [AWVideoDetailVC new];
            vc.receiveVideoUrl = responseObject[@"data"][@"url"];
            vc.receiveTitle = videoName;
            [targetVC.navigationController pushViewController:vc animated:YES];

        }
    } failure:^(NSError * _Nonnull error) {
         [SVProgressHUD dismiss];
    }];
}

-(void)jumpDetailMethod:(NSString *)videoName url:(NSString *)videoUrl withTargetVC:(UIViewController *)targetVC
{
    NSLog(@"entern this method");
    
    AWVideoDetailVC *vc = [AWVideoDetailVC new];
    vc.receiveVideoUrl = videoUrl;
    vc.receiveTitle = videoName;
    [targetVC.navigationController pushViewController:vc animated:YES];

}

//处理view 回调跳转
- (UIViewController *)viewController {
    for (UIView * next = [self superview]; next; next = next.superview) {
        UIResponder * nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
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
