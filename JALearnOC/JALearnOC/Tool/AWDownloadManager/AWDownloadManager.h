//
//  AWDownloadManager.h
//  JALearnOC
//
//  Created by jason on 24/7/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWDownloadItem.h"

#define MAXTASK_COUNT 3

@interface AWDownloadManager : NSObject


/** 最大任务数量*/
@property (nonatomic, assign) int AW_MaxTaskCount;

// 存放需要下载的数组
@property (nonatomic, strong) NSMutableArray *AW_DownloadArray;


+(instancetype)shareManager;

/**
 开始下载
 
 @param downloadUrl 下载的路径
 @param requestMethod 请求的方法
 @param customCacheName 自定义的缓存的名字
 */
- (void)AW_DownloadWithUrl:(NSString *)downloadUrl
                withMethod:(NSString *)requestMethod
       withCustomCacheName:(NSString *)customCacheName;
/**
 开始下载
 
 @param downloadUrl 下载的路径 (请求的方式是get)
 @param customCacheName 自定义的缓存的名字
 */
- (void)AW_DownloadWithUrl:(NSString *)downloadUrl
       withCustomCacheName:(NSString *)customCacheName;

/**
 暂停某一个下载
 
 @param url 暂停的全下载路径
 */
- (void)AW_SuspendWithUrl:(NSString *)url;

/**
 暂停所有的下载
 */
- (void)AW_SuspendAllRequest;
/**
 恢复某一个下载
 
 @param url 下载的全链接
 */
- (void)AW_ResumeWithUrl:(NSString *)url;
/**
 恢复所有暂停的下载
 */
- (void)AW_ResumeAllRequest;
/**
 取消一个下载
 
 @param url 下载的全链接
 */
- (void)AW_CancelWithUrl:(NSString *)url;
/**
 取消所有的下载的任务
 */
- (void)AW_CancelAllRequest;

@end

