//
//  NSObject+SwizzleMethod.m
//  JALearnOC
//
//  Created by jason on 22/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "NSObject+SwizzleMethod.h"
#import <objc/runtime.h>

@implementation NSObject (SwizzleMethod)

/**
 *  对系统方法进行替换
 */
+ (void)ac_swizzleSelector:(SEL)systemSelector swizzledSelector:(SEL)swizzledSelector{
    Method systemMethod = class_getInstanceMethod(self, systemSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    if (class_addMethod([self class], systemSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod([self class], swizzledSelector, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }else{
        method_exchangeImplementations(systemMethod, swizzledMethod);
    }
}

@end
