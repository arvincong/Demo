//
//  AWDownloadItem.h
//  JALearnOC
//
//  Created by jason on 24/7/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AWHttpConfig.h"
#import "AWDownloadItem.h"

NS_ASSUME_NONNULL_BEGIN

// 是否下载 1.未下载 2.等待中 3.正在下载  4.下载完成  5.暂停 6.下载失败
typedef NS_ENUM(NSUInteger,AWDownloadStatus) {
    
    AWDownloadStatusUnKnown            = 0,
    AWDownloadStatusUndownload         = 1,
    AWDownloadStatusWaiting            = 2,
    AWDownloadStatusDownloading        = 3,
    AWDownloadStatusDownloadFinish     = 4,
    AWDownloadStatusDownloadSuspend    = 5,
    AWDownloadStatusError              = 6
};

@interface AWDownloadItem : NSObject

/** 下载的自定义的缓存文件名*/
@property (nonatomic, copy) NSString *customCacheName;
/** 请求的url */
@property (nonatomic, copy) NSString *requestUrl;
/** 下载的任务 */
@property (nonatomic, strong) NSURLSessionTask *task;
/** 管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
/** 下载的状态 */
@property (nonatomic, assign) AWDownloadStatus downloadStatus;
/** 返回的response */
@property (nonatomic, strong) NSURLResponse *response;
/** 错误的信息 */
@property (nonatomic, strong) NSError *error;
/** 下载的进度 */
@property (nonatomic, assign) CGFloat progress;
/** 临时存储的文件路径 */
@property (nonatomic, copy) NSString *temPath;
/** 缓存的文件的路径 */
@property (nonatomic, copy) NSString *cachePath;
/** 请求的方法 */
@property (nonatomic, copy) NSString *requestMethod;
/** 参数 */
@property (nonatomic, strong) NSDictionary *paramDic;
/** NSFileHandle */
@property (nonatomic, strong) NSFileHandle *itemFileHandle;

//  下载进度的block
@property (nonatomic, strong) void (^AWDownloadProgressBlock)(CGFloat progress);
//  下载信息反馈
@property (nonatomic, strong) void (^AWDownloadCompletionHandler)(NSError *error);

@end

NS_ASSUME_NONNULL_END
