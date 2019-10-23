//
//  NSObject+SwizzleMethod.h
//  JALearnOC
//
//  Created by jason on 22/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SwizzleMethod)

/**
 *  对系统方法进行替换(交换实例方法)
 */
+ (void)ac_swizzleSelector:(SEL)systemSelector swizzledSelector:(SEL)swizzledSelector;

@end

NS_ASSUME_NONNULL_END
