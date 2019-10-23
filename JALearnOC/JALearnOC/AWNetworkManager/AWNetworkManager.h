//
//  AWNetworkManager.h
//  JALearnOC
//
//  Created by jason on 10/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWNetworkManager : NSObject

@property(nonatomic,assign) NSInteger networkStatusCode;

+ (instancetype)sharedInstance;

/**
 *  发送get请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;


/**
get 请求添加重试机制
 
 *
 *  @param URLString     请求的网址字符串
 *  @param parameters    请求的参数
 *  @param success       请求成功的回调
 *  @param failure       请求失败的回调
 *  @param jsonFormat    请求是json格式
 *  @param retryCount    重试次数
 *  @param retryInterval 重试时长
 */

- (void)getWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
               jsonFormat:(BOOL)jsonFormat
               retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval;



/**
 *  发送post请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;



/**
   post 请求添加重试机制
 
 *
 *  @param URLString     请求的网址字符串
 *  @param parameters    请求的参数
 *  @param success       请求成功的回调
 *  @param failure       请求失败的回调
 *  @param jsonFormat    请求是json格式
 *  @param retryCount    重试次数
 *  @param retryInterval 重试时长
 */

- (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
               jsonFormat:(BOOL)jsonFormat
                  retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval;

/**
 *  下载数据
 *
 *  @param URLString   下载数据的网址
 *  @param parameters  下载数据的参数
 *  @param success     下载成功的回调
 *  @param failure     下载失败的回调
 */
- (void)downLoadWithURLString:(NSString *)URLString
                   parameters:(id)parameters
                     progerss:(void (^)(void))progress
                      success:(void (^)(void))success
                      failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
