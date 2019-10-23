//
//  AWFileManager.m
//  JALearnOC
//
//  Created by jason on 24/7/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWFileManager.h"

@implementation AWFileManager
/**
 *
 *   创建目录
 */
+ (BOOL)AW_CreatPath:(NSString *)path{
    if (path.length > 0) {
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        BOOL flag = [manager createFileAtPath:path contents:nil attributes:nil];
        return flag;
    }
    return NO;
}
/**
 *
 *   判断路径是佛存在
 */
+ (BOOL)AW_FileIsExist:(NSString *)path{
    if (path.length > 0) {
        NSFileManager *manager = [NSFileManager defaultManager];
        return [manager fileExistsAtPath:path];
    }
    return NO;
}
/**
 *
 *   删除文件
 */
+ (BOOL)AW_DeleteFile:(NSString *)path{
    if (path.length > 0) {
        NSFileManager * manager = [NSFileManager defaultManager];
        return [manager removeItemAtPath:path error:nil];
    }
    return NO;
    
}
/**
 *
 *   获取缓存的文件夹路径
 */
+ (NSString *)AW_GetCachePath{
    
    return [[NSSearchPathForDirectoriesInDomains(NSMusicDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"/AW_LocalMusic"];
}
@end
