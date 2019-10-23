//
//  AWDownloadManager.m
//  JALearnOC
//
//  Created by jason on 24/7/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWDownloadManager.h"
#import "NSDataAdditions.h"

@interface AWDownloadManager()

@property(nonatomic, strong)NSLock *lock;

@end

@implementation AWDownloadManager
+ (instancetype)shareManager {
    static AWDownloadManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}
-(instancetype)init {
    if (self == [super init]) {
        _lock = [[NSLock alloc] init];
    }
    return self;
}
#pragma mark - 懒加载
-(NSMutableArray *)AW_DownloadArray {
    if (!_AW_DownloadArray) {
        _AW_DownloadArray = [NSMutableArray array];
    }
    return _AW_DownloadArray;
}
#pragma mark - 外部调用的方法
/**
 开始下载
 
 @param downloadUrl 下载的路径
 @param requestMethod 请求的方法
 @param customCacheName 自定义的缓存的名字
 */
- (void)AW_DownloadWithUrl:(NSString *)downloadUrl
                withMethod:(NSString *)requestMethod
       withCustomCacheName:(NSString *)customCacheName{
    
    if (downloadUrl.length == 0) { return;}
    [_lock lock];
    // 取消下载相关的东西
    AWDownloadItem *item = [self getItemFromArray:_AW_DownloadArray withUrl:downloadUrl];
    if (!item) {
        item = [[AWDownloadItem alloc] init];
        item.requestUrl = downloadUrl;
        item.downloadStatus = AWDownloadStatusWaiting;
        item.progress = 0.0;
        item.customCacheName = customCacheName;
        item.temPath = [self getTemPath:downloadUrl];
        // 方案二需要这样写
        item.cachePath = [self getCache:downloadUrl withResponse:nil customCahceName:customCacheName];
        item.requestMethod = requestMethod;
        item.paramDic = nil;
        // 已经下载的就不用下载了
        if ([[NSFileManager defaultManager] attributesOfItemAtPath:item.cachePath error:nil].fileSize <= 0) {
            [self.AW_DownloadArray addObject:item];
        }
    }
    // 设置最大线程来进行下载任务
    [self AW_CheckDownload];
    [_lock unlock];
}
/**
 开始下载
 
 @param downloadUrl 下载的路径 (请求的方式是get)
 @param customCacheName 自定义的缓存的名字
 */
- (void)AW_DownloadWithUrl:(NSString *)downloadUrl
       withCustomCacheName:(NSString *)customCacheName{
    if (downloadUrl.length == 0) { return;}
    [_lock lock];
    // 取消下载相关的东西
    AWDownloadItem *item = [self getItemFromArray:_AW_DownloadArray withUrl:downloadUrl];
    if (!item) {
        item = [[AWDownloadItem alloc] init];
        item.requestUrl = downloadUrl;
        item.downloadStatus = AWDownloadStatusWaiting;
        item.progress = 0.0;
        item.customCacheName = customCacheName;
        item.temPath = [self getTemPath:downloadUrl];
        // 方案二需要这样写
        item.cachePath = [self getCache:downloadUrl withResponse:nil customCahceName:customCacheName];
        item.requestMethod = @"GET";
        item.paramDic = nil;
        // 已经下载的就不用下载了
        if ([[NSFileManager defaultManager] attributesOfItemAtPath:item.cachePath error:nil].fileSize <= 0) {
            [self.AW_DownloadArray addObject:item];
        }
    }
    // 设置最大线程来进行下载任务
    [self AW_CheckDownload];
    [_lock unlock];
    
}
/**
 暂停某一个下载
 
 @param url 暂停的全下载路径
 */
- (void)AW_SuspendWithUrl:(NSString *)url{
    
    if (url.length == 0) {
        return;
    }
    [_lock lock];
    AWDownloadItem *item = [self getItemFromArray:_AW_DownloadArray withUrl:url];
    [item.task suspend];
    item.downloadStatus = AWDownloadStatusDownloadSuspend;
    // 暂停某一首歌曲
    [[NSNotificationCenter defaultCenter] postNotificationName:AWSuspendOneSong object:nil];
    [_lock unlock];
    
}

/**
 暂停所有的下载
 */
- (void)AW_SuspendAllRequest{
    [_lock lock];
    for (AWDownloadItem *item in _AW_DownloadArray) {
        if (item.downloadStatus == AWDownloadStatusDownloading || item.downloadStatus == AWDownloadStatusWaiting || item.downloadStatus == AWDownloadStatusError) {
            [item.task suspend];
            item.downloadStatus = AWDownloadStatusDownloadSuspend;
        }
    }
    [_lock unlock];
    // 暂停所有的歌曲（通知）
    [[NSNotificationCenter defaultCenter] postNotificationName:AWSuspendAllSong object:nil];
}
/**
 恢复某一个下载
 
 @param url 下载的全链接
 */
- (void)AW_ResumeWithUrl:(NSString *)url{
    if (url.length == 0) {
        return;
    }
    [_lock lock];
    AWDownloadItem *item = [self getItemFromArray:_AW_DownloadArray withUrl:url];
    if (!item) {
        item = [[AWDownloadItem alloc] init];
        item.requestUrl = url;
        item.downloadStatus = AWDownloadStatusWaiting;
        item.progress = 0.0;
        item.temPath = [self getTemPath:url];
        item.paramDic = nil;
        [_AW_DownloadArray addObject:item];
    }else {
        item.downloadStatus = AWDownloadStatusWaiting;
    }
    [self AW_CheckDownload];
    [_lock unlock];
    [[NSNotificationCenter defaultCenter] postNotificationName:AWResumeOneSong object:nil];
}
/**
 恢复所有暂停的下载
 */
- (void)AW_ResumeAllRequest{
    [_lock lock];
    for (AWDownloadItem *item in _AW_DownloadArray) {
        if (item.downloadStatus != AWDownloadStatusError || item.downloadStatus != AWDownloadStatusDownloadFinish) {
            item.downloadStatus = AWDownloadStatusWaiting;
        }
    }
    [self AW_CheckDownload];
    [_lock unlock];
    [[NSNotificationCenter defaultCenter] postNotificationName:AWResumeAllSong object:nil];
}
/**
 取消一个下载
 
 @param url 下载的全链接
 */
- (void)AW_CancelWithUrl:(NSString *)url{
    if (url.length == 0) {
        return;
    }
    [_lock lock];
    AWDownloadItem *item = [self getItemFromArray:_AW_DownloadArray withUrl:url];
    if (item.downloadStatus == AWDownloadStatusDownloadFinish) {
        return;
    }else {
        [item.task cancel];
        item.task = nil;
        // 删除临时文件夹的缓存东西
        [[NSFileManager defaultManager] removeItemAtPath:item.temPath error:nil];
    }
    if (item) {
        [_AW_DownloadArray removeObject:item];
    }
    [_lock unlock];
    [[NSNotificationCenter defaultCenter] postNotificationName:AWCancelOneSong object:nil];
}
/**
 取消所有的下载的任务
 */
- (void)AW_CancelAllRequest{
    [_lock lock];
    for (AWDownloadItem *item in _AW_DownloadArray) {
        [item.task cancel];
        item.task = nil;
        // 删除临时文件夹的缓存东西
        [[NSFileManager defaultManager] removeItemAtPath:item.temPath error:nil];
    }
    [_AW_DownloadArray removeAllObjects];
    _AW_DownloadArray = nil;
    [_lock unlock];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AWCancelAllSong object:nil];
}
#pragma mark - 自身需要实现的方法
/**
 便利数组获取item
 
 @param itemArray 传递的数组
 @param url url
 @return 单个下载的对象
 */
- (AWDownloadItem *)getItemFromArray:(NSArray <AWDownloadItem *>*)itemArray withUrl:(NSString *)url {
    AWDownloadItem *getItem = nil;
    for (AWDownloadItem *item in itemArray) {
        if ([item.requestUrl isEqualToString:url]) {
            getItem = item;
            break;
        }
    }
    return getItem;
}
/**
 获取临时文件夹 (全路径）
 
 @param downloadUrl 下载的全路径
 @return 临时文件的路径
 */
-  (NSString *)getTemPath:(NSString *)downloadUrl {
    
    if (downloadUrl.length <= 0) {
        return nil;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *temPath = NSTemporaryDirectory();
    NSString *nameStr =[[[downloadUrl dataUsingEncoding:NSUTF8StringEncoding] AW_MD5HashString] stringByAppendingString:@".download"];
    temPath = [temPath stringByAppendingPathComponent:nameStr];
    if (![fileManager fileExistsAtPath:temPath]) {
        [fileManager createFileAtPath:temPath contents:nil attributes:nil];
    }
    return temPath;
}
/**
 *
 *   获取缓存的文件夹的路径
 */
- (NSString *)getCache:(NSString *)downloadUrl withResponse:(NSURLResponse *)response customCahceName:(NSString *)customCacheName{
    
    if (downloadUrl.length <= 0) {
        return nil;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"AWMusic"];
    if (![fileManager fileExistsAtPath:cachePath]) {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 方案一 用服务建议的方法命名
    //    cachePath = [cachePath stringByAppendingPathComponent:response.suggestedFilename];
    // 方案二 自己用md5 或者其他的方式加密命名
    if (customCacheName.length > 0) {
        cachePath = [cachePath stringByAppendingPathComponent:customCacheName];
    }else {
        cachePath = [cachePath stringByAppendingPathComponent:[[[downloadUrl dataUsingEncoding:NSUTF8StringEncoding] AW_MD5HashString] stringByAppendingString:@".download"]];
    }
    if (![fileManager fileExistsAtPath:cachePath]) {
        [fileManager createFileAtPath:cachePath contents:nil attributes:nil];
    }
    return cachePath;
}

/**
 检查下载相关的
 */
- (void)AW_CheckDownload {
    
    NSInteger downloadingCount = 0;
    BOOL flag = YES;
    for (AWDownloadItem *item in _AW_DownloadArray) {
        if (item.downloadStatus == AWDownloadStatusDownloading) {
            downloadingCount ++;
        }
        if (self.AW_MaxTaskCount == 0) {
            self.AW_MaxTaskCount = MAXTASK_COUNT;
        }
        if (downloadingCount >= self.AW_MaxTaskCount) {
            flag = NO;
            break;
        }
    }
    NSLog(@"当前的下载数量是:%zd",downloadingCount);
    if (flag) {
        for (AWDownloadItem *item in _AW_DownloadArray) {
            if (item.downloadStatus == AWDownloadStatusWaiting) {
                if (self.AW_MaxTaskCount == 0) {
                    self.AW_MaxTaskCount = MAXTASK_COUNT;
                }
                if (self.AW_MaxTaskCount - downloadingCount > 0) {
                    NSLog(@"开始任务了");
                    [self AW_BeginDownloadWithItem:item];
                    downloadingCount ++;
                }else {
                    break;
                }
            }
        }
    }
}
/**
 开始单个下载的任务
 
 @param item item
 */
- (void)AW_BeginDownloadWithItem:(AWDownloadItem *)item {
    
    if (item.requestUrl.length == 0) {
        return;
    }
    item.downloadStatus = AWDownloadStatusDownloading;
    //  如果任务正在进行 取消
    [self AW_CancelTask:item];
    //  取消请求的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    //  开始下载任务
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:item.requestMethod URLString:item.requestUrl parameters:item.paramDic error:nil];
    // 读取数据
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:item.temPath error:nil];
    unsigned long long cacheNumber = dic.fileSize;
    // 断点续传
    if (cacheNumber > 0) {
        NSString *rangStr = [NSString stringWithFormat:@"bytes=%llu-",cacheNumber];
        [request setValue:rangStr forHTTPHeaderField:@"Range"];
    }
    __weak typeof(self)weakSelf = self;
    [manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
        [weakSelf.lock lock];
        
        item.downloadStatus = AWDownloadStatusDownloading;
        // 写入数据
        if (!item.itemFileHandle) {
            item.itemFileHandle = [NSFileHandle fileHandleForWritingAtPath:item.temPath];
        }
        [item.itemFileHandle seekToEndOfFile];
        [item.itemFileHandle writeData:data];
        // 计算进度
        unsigned long long receiveNumber = (unsigned long long )dataTask.countOfBytesReceived + cacheNumber;
        unsigned long long expectNumber = (unsigned long long)dataTask.countOfBytesExpectedToReceive + cacheNumber;
        CGFloat progress = (CGFloat)receiveNumber/expectNumber *1.0;
        item.progress = progress;
        NSLog(@"接收的数据 --- %llu 期望的数据 ---- %llu 下载的进度 --- %f",receiveNumber,expectNumber,progress);
        if (item.AWDownloadProgressBlock) {
            item.AWDownloadProgressBlock(progress);
        }
        [weakSelf.lock unlock];
    }];
    // 完成
    item.task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [weakSelf.lock lock];
        item.error = error;
        if (error) {
            NSLog(@"下载失败 %@",error);
            item.downloadStatus = AWDownloadStatusError;
            if (item.AWDownloadCompletionHandler) {
                item.AWDownloadCompletionHandler(error);
            }
        }else {
            item.downloadStatus = AWDownloadStatusDownloadFinish;
            // 这个路径要根据自己的实际情况处理
            item.cachePath = [weakSelf getCache:item.requestUrl withResponse:response customCahceName:item.customCacheName];
            NSLog(@"下载成功 -- 成功的文件的路径是%@",item.cachePath);
            // 删除文件，防止出现错误
            [[NSFileManager defaultManager] removeItemAtPath:item.cachePath error:nil];
            // 存放到自己想存放的路径
            NSError *transError = nil;
            [[NSFileManager defaultManager] moveItemAtPath:item.temPath toPath:item.cachePath error:&transError];
            NSLog(@"转换的错误信息是 %@",transError);
            
#warning 保留下载的文件，不删除
            // 从数组中移除成功的
//            [weakSelf.AW_DownloadArray removeObject:item];
//            // 删除临时的文件
//            [[NSFileManager defaultManager] removeItemAtPath:item.temPath error:nil];
            
            if (item.AWDownloadCompletionHandler) {
                item.AWDownloadCompletionHandler(nil);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:AWDownloadFinish object:nil];
            item.response = response;
            // 递归调用
            [weakSelf AW_CheckDownload];
        }
        [weakSelf.lock unlock];
    }];
    
    [item.task resume];
    item.manager = manager;
}
/**
 *
 *  取消正在下载的任务
 */
- (void)AW_CancelTask:(AWDownloadItem *)item {
    
    if (item.task) {
        [item.task cancel];
        item.task = nil;
    }
    item.progress = 0;
    [item.manager setDataTaskDidReceiveDataBlock:NULL];
    item.response = nil;
    item.error = nil;
}

@end
