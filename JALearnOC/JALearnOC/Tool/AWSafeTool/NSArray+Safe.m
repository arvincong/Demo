//
//  NSArray+Safe.m
//  JALearnOC
//
//  Created by jason on 22/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "NSArray+Safe.h"
#import "NSObject+SwizzleMethod.h"
#import <objc/runtime.h>

@implementation NSArray (Safe)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSArrayI") ac_swizzleSelector:@selector(objectAtIndex:) swizzledSelector:@selector(safe_objectAtIndex:)];
        [objc_getClass("__NSArrayI") ac_swizzleSelector:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(safe_objectAtIndexedSubscript:)];
    });
}
- (id)safe_objectAtIndex:(NSUInteger)index{
    if (index < self.count) {
        return [self safe_objectAtIndex:index];
    }else{
        return nil;
    }
}
- (id)safe_objectAtIndexedSubscript:(NSUInteger)idx{
    if (idx < self.count) {
        return [self safe_objectAtIndexedSubscript:idx];
    }else{
        return nil;
    }
}

@end
