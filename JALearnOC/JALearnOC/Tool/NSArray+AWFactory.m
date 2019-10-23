//
//  NSArray+AWFactory.m
//  JALearnOC
//
//  Created by jason on 24/7/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "NSArray+AWFactory.h"

@implementation NSArray (AWFactory)

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end
