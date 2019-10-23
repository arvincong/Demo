//
//  AWPlayerListCell.h
//  JALearnOC
//
//  Created by jason on 8/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWVideoModel.h"

#import "AWVideoListModel.h"
#import "AWVideoDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AWPlayerListCell : UITableViewCell

@property(nonatomic,strong)UIImageView *videoImageView;

@property(nonatomic,strong)UILabel *videoTitleLabel;

@property(nonatomic,strong)UIButton *videoListBtn;

@property(nonatomic,strong)UIView *videoContentView; //放剧集列表的

//新的剧集显示
-(void)fillVideoContentViewMethod:(AWVideoListModel *)listModel withOriginalVC:(UIViewController *)originalVC;

-(void)fillVideoViewMethod:(AWVideoModel *)model withOriginalVC:(UIViewController *)originalVC;

@end

NS_ASSUME_NONNULL_END
