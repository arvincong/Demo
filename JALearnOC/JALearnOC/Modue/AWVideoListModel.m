//
//  AWVideoListModel.m
//  JALearnOC
//
//  Created by jason on 10/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWVideoListModel.h"

@implementation AWVideoListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"detailArray" : [AWVideoDetailModel class]};
}

@end
