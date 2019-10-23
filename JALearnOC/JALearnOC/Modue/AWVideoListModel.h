//
//  AWVideoListModel.h
//  JALearnOC
//
//  Created by jason on 10/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWVideoDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AWVideoListModel : NSObject

@property(nonatomic,strong)NSString *title;

@property(nonatomic,strong)NSString *img;

@property(nonatomic,strong)NSString *series;

@property(nonatomic,strong)NSString *url;

@property(nonatomic,assign)BOOL isOpen;

@property(nonatomic,strong)NSArray<AWVideoDetailModel *> *detailArray;

@property(nonatomic,strong)NSString *episode; //集数

@property(nonatomic,strong)NSString *command; //显示


@end

NS_ASSUME_NONNULL_END
