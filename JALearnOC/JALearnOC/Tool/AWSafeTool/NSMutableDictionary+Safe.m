//
//  NSMutableDictionary+Safe.m
//  JALearnOC
//
//  Created by jason on 22/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "NSMutableDictionary+Safe.h"
#import "NSObject+SwizzleMethod.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (Safe)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self ac_swizzleSelector:@selector(setObject:forKey:) swizzledSelector:@selector(safe_setObject:forKey:)];
        [self ac_swizzleSelector:@selector(removeObjectForKey:) swizzledSelector:@selector(safe_removeObjectForKey:)];
    });
}
- (void)safe_setObject:(id)anObject forKey:(id<NSCopying>)aKey{
    if (anObject && aKey){
        [self safe_setObject:anObject forKey:aKey];
    }else{
        return;
    }
}

- (void)safe_removeObjectForKey:(id<NSCopying>)key{
    if (key) {
        [self safe_removeObjectForKey:key];
    }else{
        return;
    }
}

@end
