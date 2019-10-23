//
//  AWDownloadEpisodeVC.h
//  JALearnOC
//
//  Created by jason on 23/7/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "BaseViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface AWDownloadEpisodeVC : BaseViewController

@property(nonatomic,strong)NSString *episodeNameStr; //剧集名称

@property(nonatomic,strong)NSArray *receiveDataArray; //剧集列表

@end

NS_ASSUME_NONNULL_END
