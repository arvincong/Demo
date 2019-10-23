//
//  AWUserDefaultCache.h
//  JALearnOC
//
//  Created by jason on 22/5/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWUserDefaultCache : NSObject

+(void)saveData:(id)data withKey:(NSString *)serviceKey;

+(id)load:(NSString *)serviceKey;

+(void)deleteKeyData:(NSString *)serviceKey;

@end

NS_ASSUME_NONNULL_END
