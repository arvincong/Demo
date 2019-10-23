//
//  AWVideoDetailModel.h
//  JALearnOC
//
//  Created by jason on 10/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWVideoDetailModel : NSObject

@property(nonatomic,strong)NSString *name;

@property(nonatomic,strong)NSString *url;

@property(nonatomic,assign)BOOL isSelected; //选中集数标记



@end

NS_ASSUME_NONNULL_END
