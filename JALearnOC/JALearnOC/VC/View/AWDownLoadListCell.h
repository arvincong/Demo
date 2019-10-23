//
//  AWDownLoadListCell.h
//  JALearnOC
//
//  Created by jason on 23/7/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWDownloadItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface AWDownLoadListCell : UITableViewCell

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UIProgressView *progressView;

@property(nonatomic,strong)UILabel *progressLabel; //进度说明

@property(nonatomic,strong)UIButton *statusBtn; //功能按钮，下载或者暂停

@property(nonatomic,strong) AWDownloadItem *loadItem;

@end

NS_ASSUME_NONNULL_END
