//
//  AWUserDefaultCache.m
//  JALearnOC
//
//  Created by jason on 22/5/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWUserDefaultCache.h"
#import "AWJsonTools.h"
#import <objc/runtime.h>

@implementation AWUserDefaultCache

static const NSString * dataKey = @"kcacheData";

+(void)saveData:(id)data withKey:(NSString *)serviceKey
{
    
    if(data != nil){

        NSDictionary *dic = nil;
        
        unsigned int propsCount;

        objc_property_t *props = class_copyPropertyList([data class], &propsCount);
        
        if(props){
            
            dic = [NSDictionary dictionaryWithObject:[AWJsonTools getObjectData:data] forKey:dataKey];
            
        }else{
            dic = [NSDictionary dictionaryWithObject:data forKey:dataKey];
            
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:dic forKey:serviceKey];
        [userDefaults synchronize];
    }

}

+(id)load:(NSString *)serviceKey
{
    //做解析
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:serviceKey]){
         return [[userDefaults objectForKey:serviceKey] objectForKey:dataKey];
    }else{
        
        return nil;
    }
   
}


+(void)deleteKeyData:(NSString *)serviceKey
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:serviceKey];
    [userDefaults synchronize];
}

@end
