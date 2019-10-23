//
//  AWPublicDetailVC.h
//  JALearnOC
//
//  Created by jason on 11/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "BaseViewController.h"
#import "AWVideoListModel.h"
#import "AWVideoDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AWPublicDetailVC : BaseViewController

@property(nonatomic,strong)AWVideoListModel *receivePlayerModel;

//播放视频方法
-(void)playVideoMethod:(AWVideoDetailModel *)originalModel withTargetUrl:(NSString *)targetUrl;

@end

NS_ASSUME_NONNULL_END
