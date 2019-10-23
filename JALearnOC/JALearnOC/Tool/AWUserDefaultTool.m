//
//  AWUserDefaultTool.m
//  KouZiDai
//
//  Created by jason on 21/5/2019.
//  Copyright © 2019 arvin wang. All rights reserved.
//

#import "AWUserDefaultTool.h"

@implementation AWUserDefaultTool

+ (void)save:(NSString*)service data:(id)data
{
    if (service!=NULL&&data!=NULL) {
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        [userDefaults setObject:data forKey:service];
        [userDefaults synchronize];
    }
    
}

+ (id)load:(NSString*)service
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    id obj;
    if (service!=NULL) {
        obj=[userDefaults objectForKey:service];
    }
    return obj;
    
}

+ (void)deleteKeyData:(NSString*)service
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:service];
    [userDefaults synchronize];
}

@end
