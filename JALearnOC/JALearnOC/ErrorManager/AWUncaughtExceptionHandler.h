//
//  AWUncaughtExceptionHandler.h
//  JALearnOC
//
//  Created by jason on 7/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWUncaughtExceptionHandler : NSObject{
    
    BOOL dismissed;
}

/*
 开启crash信息收集
 */
+ (void)setDefaultHandler;

+ (void)writeException:(NSString *)exceptionString;

+ (void)checkAndSendException;

@end

NS_ASSUME_NONNULL_END
