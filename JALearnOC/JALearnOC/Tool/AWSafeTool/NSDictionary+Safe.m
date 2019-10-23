//
//  NSDictionary+Safe.m
//  JALearnOC
//
//  Created by jason on 22/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "NSDictionary+Safe.h"
#import "NSObject+SwizzleMethod.h"
#import <objc/runtime.h>

@implementation NSDictionary (Safe)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSPlaceholderDictionary") ac_swizzleSelector:@selector(initWithObjects:forKeys:count:) swizzledSelector:@selector(safe_initWithObjects:forKeys:count:)];
    });
}

-(instancetype)safe_initWithObjects:(id *)objects forKeys:(id<NSCopying> *)keys count:(NSUInteger)count
{
    NSUInteger rightCount = 0;
    for (NSUInteger i = 0; i < count; i++) {
        if (!(keys[i] && objects[i])) {
            break;
        }else{
            rightCount++;
        }
    }
    
    return  [self safe_initWithObjects:objects forKeys:keys count:count];
}
@end
