//
//  AWM3U8Playlist.h
//  JALearnOC
//
//  Created by jason on 25/7/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWM3U8Playlist : NSObject

@property (strong, nonatomic) NSArray *segmentArray;

@property (copy, nonatomic) NSString *uuid;

@property (assign, nonatomic) NSInteger length;

/**
 * 设置
 */
- (void)initWithSegmentArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
