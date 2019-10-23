//
//  AWFileManager.h
//  JALearnOC
//
//  Created by jason on 24/7/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWFileManager : NSObject
/**
 *
 *   创建目录
 */
+ (BOOL)AW_CreatPath:(NSString *)path;
/**
 *
 *   判断路径是佛存在
 */
+ (BOOL)AW_FileIsExist:(NSString *)path;
/**
 *
 *   删除文件
 */
+ (BOOL)AW_DeleteFile:(NSString *)path;
/**
 *
 *   获取缓存的文件夹路径
 */
+ (NSString *)AW_GetCachePath;

@end

NS_ASSUME_NONNULL_END
