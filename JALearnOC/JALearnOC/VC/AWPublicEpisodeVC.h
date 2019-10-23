//
//  AWPublicEpisodeVC.h
//  JALearnOC
//
//  Created by jason on 12/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWPublicDetailVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface AWPublicEpisodeVC : BaseViewController

@property(nonatomic,strong)NSArray *receiveEpisodeArray;

@property(nonatomic,strong)AWPublicDetailVC *receiveOriginalVC;


-(void)changeBtnColorMethod:(id)originalBtn;

-(void)getVideoPlayerUrlMethod:(AWVideoDetailModel *)detailModel;


@end

NS_ASSUME_NONNULL_END
