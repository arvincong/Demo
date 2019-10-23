//
//  AWHttpConfig.h
//  JALearnOC
//
//  Created by jason on 24/7/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWHttpConfig : NSObject

#pragma mark - 借口的配置

extern  NSString * const AWDownloadFinish;
extern  NSString * const AWCancelAllSong;
extern  NSString * const AWCancelOneSong;
extern  NSString * const AWResumeAllSong;
extern  NSString * const AWResumeOneSong;
extern  NSString * const AWSuspendAllSong;
extern  NSString * const AWSuspendOneSong;

@end

NS_ASSUME_NONNULL_END
