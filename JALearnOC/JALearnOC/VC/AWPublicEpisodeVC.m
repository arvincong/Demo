//
//  AWPublicEpisodeVC.m
//  JALearnOC
//
//  Created by jason on 12/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWPublicEpisodeVC.h"
#import "AWVideoDetailModel.h"
#import "AWPublicDetailVC.h"

@interface AWPublicEpisodeVC ()

@end

@implementation AWPublicEpisodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self createUIMethod];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Custom Method
-(void)createUIMethod
{
    
    __block UIButton *lastBtn = nil;
    
    __weak typeof(self) weakSelf = self;
    
    CGFloat originalWidth = (SCREEN_WIDTHL - 15*6)/5;
    
    [_receiveEpisodeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AWVideoDetailModel *model = (AWVideoDetailModel *)obj;
        
        UIButton *currentBtn = [UIButton new];
        currentBtn.tag = 100 + idx;
        currentBtn.layer.masksToBounds = YES;
        currentBtn.layer.borderWidth = 1;
        currentBtn.layer.borderColor = [UIColor colorWithHexString:@"#6e6f71"].CGColor;
        [currentBtn setTitle:model.name forState:UIControlStateNormal];
        [currentBtn setTitleColor:[UIColor colorWithHexString:@"#6e6f71"] forState:UIControlStateNormal];
        currentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        currentBtn.backgroundColor = [UIColor clearColor];
        [self.view addSubview:currentBtn];
        
        [currentBtn addAction:^(id  _Nonnull sender) {
            [weakSelf changeBtnColorMethod:sender];
            [weakSelf getVideoPlayerUrlMethod:model];
        }];
        
        [currentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(lastBtn){
                if(idx % 5 == 0){
                    make.left.equalTo(self.view.mas_left).offset(15);
                    make.top.equalTo(lastBtn.mas_bottom).offset(15);
                }else{
                    make.left.equalTo(lastBtn.mas_right).offset(15);
                    make.top.equalTo(lastBtn.mas_top);
                }
            }else{
                make.top.equalTo(self.view.mas_top).offset(15);
                make.left.equalTo(self.view.mas_left).offset(15);
            }
            make.size.mas_equalTo(CGSizeMake(originalWidth,30));
        }];
        
        
        lastBtn = currentBtn;
    }];
}

-(void)getVideoPlayerUrlMethod:(AWVideoDetailModel *)detailModel
{
    [SVProgressHUD showLoadingHUDInWindow:@"准备中..."];
    
     __weak typeof(self) weakSelf = self;
    [[AWNetworkManager sharedInstance] getWithURLString:[NSString stringWithFormat:@"%@%@",MLGB_API_URL,VIDEO_PLAYURL_API] parameters:@{@"url":detailModel.url} success:^(id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        
        if([responseObject[@"code"] integerValue] == 0){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *playUrl = responseObject[@"data"][@"url"];
                //播放视频
                NSLog(@"this url is %@",playUrl);
                [weakSelf.receiveOriginalVC playVideoMethod:detailModel withTargetUrl:playUrl];
            });
        
        }else{
            [weakSelf.view.window makeToast:@"暂时无法播放"];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"this errot result is %@ code is %ld",error.description,(long)error.code);
        [weakSelf.view.window makeToast:@"获取视频资源失败"];
    }];
}

//改变按钮选中颜色
-(void)changeBtnColorMethod:(id)originalBtn
{
    UIButton *currentBtn = (UIButton *)originalBtn;
    
    for (UIButton *btn in self.view.subviews) {
        if([btn isEqual:currentBtn]){
            btn.layer.borderColor = [UIColor colorWithHexString:@"#00c6ff"].CGColor;
            [btn setTitleColor:[UIColor colorWithHexString:@"#00c6ff"] forState:UIControlStateNormal];
        }else{
            btn.layer.borderColor = [UIColor colorWithHexString:@"#6e6f71"].CGColor;
            [btn setTitleColor:[UIColor colorWithHexString:@"#6e6f71"] forState:UIControlStateNormal];
        }
    }
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
