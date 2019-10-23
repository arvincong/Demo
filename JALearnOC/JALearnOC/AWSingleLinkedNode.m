//
//  AWSingleLinkedNode.m
//  JALearnOC
//
//  Created by jason on 7/5/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWSingleLinkedNode.h"

@implementation AWSingleLinkedNode

- (instancetype)initWithKey:(NSString *)key
                      value:(NSString *)value
{
    if (self = [super init]) {
        _key = key;
        _value = value;
    }
    return self;
}

+ (instancetype)nodeWithKey:(NSString *)key
                      value:(NSString *)value
{
    return [[[self class] alloc] initWithKey:key value:value];
}

@end
