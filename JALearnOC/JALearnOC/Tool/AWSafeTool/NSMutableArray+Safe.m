//
//  NSMutableArray+Safe.m
//  JALearnOC
//
//  Created by jason on 22/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "NSMutableArray+Safe.h"
#import "NSObject+SwizzleMethod.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Safe)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSArrayM") ac_swizzleSelector:@selector(objectAtIndex:) swizzledSelector:@selector(safe_objectAtIndex:)];
        [objc_getClass("__NSArrayM") ac_swizzleSelector:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(safe_objectAtIndexedSubscript:)];
        [objc_getClass("__NSArrayM") ac_swizzleSelector:@selector(insertObject:atIndex:) swizzledSelector:@selector(safe_insertObject:atIndex:)];
        [objc_getClass("__NSArrayM") ac_swizzleSelector:@selector(removeObjectAtIndex:) swizzledSelector:@selector(safe_removeObjectAtIndex:)];
        [objc_getClass("__NSArrayM") ac_swizzleSelector:@selector(removeObject:) swizzledSelector:@selector(safe_removeObject:)];
        [objc_getClass("__NSArrayM") ac_swizzleSelector:@selector(addObject:) swizzledSelector:@selector(safe_addObject:)];
    });
}
- (void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index{
    if (anObject && index <= [self count]){
        [self safe_insertObject:anObject atIndex:index];
    }else{
        return;
    }
}
- (void)safe_addObject:(id)anObject{
    if (anObject){
        [self safe_addObject:anObject];
    }else{
        return;
    }
}

- (void)safe_removeObjectAtIndex:(NSUInteger)index{
    if (index < [self count]) {
        [self safe_removeObjectAtIndex:index];
    }else{
        return;
    }
}

- (void)safe_removeObject:(id)anObject{
    if (anObject) {
        [self safe_removeObject:anObject];
    }else{
        return;
    }
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
