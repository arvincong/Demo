//
//  AWUserDefaultTool.h
//  KouZiDai
//
//  Created by jason on 21/5/2019.
//  Copyright © 2019 arvin wang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWUserDefaultTool : NSObject

+ (void)save:(NSString*)service data:(id)data;

+ (id)load:(NSString*)service;

+ (void)deleteKeyData:(NSString*)service;

@end

NS_ASSUME_NONNULL_END
