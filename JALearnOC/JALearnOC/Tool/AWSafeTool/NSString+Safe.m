//
//  NSString+Safe.m
//  JALearnOC
//
//  Created by jason on 22/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "NSString+Safe.h"
#import "NSObject+SwizzleMethod.h"
#import <objc/runtime.h>

@implementation NSString (Safe)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSCFConstantString") ac_swizzleSelector:@selector(isEqualToString:) swizzledSelector:@selector(safe_isEqualToString:)];
    });
}

-(BOOL)safe_isEqualToString:(NSString *)targetString{
    
    if(!self.length){
        
        return NO;
    }
    
    if(!targetString.length){
        
        return NO;
    }
    
    return [self safe_isEqualToString:targetString];
}

@end
