//
//  AWUncaughtExceptionHandler.m
//  JALearnOC
//
//  Created by jason on 7/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWUncaughtExceptionHandler.h"
static NSString *ExceptionFileName = @"Exception";
static NSString *FilePrex = @"NoUpload_";
static NSString *kCrashFileUploadedTime = @"CrashFileUploadedLastTime";
static int MaxCountOfUploadedCrashFile = 10;

void handleException(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = exception.reason;
    NSString *name = exception.name;
    
    NSString *exceptionString = [NSString stringWithFormat:@"name:              %@\n"
                                 "reason:             %@\n\n"
                                 "callStackSymbols:\n%@",
                                 name,
                                 reason,
                                 [arr componentsJoinedByString:@"\n"]];
    [AWUncaughtExceptionHandler writeException:exceptionString];
}

@implementation AWUncaughtExceptionHandler

//开启日志监测功能
+ (void)setDefaultHandler {
    NSSetUncaughtExceptionHandler (&handleException);
    
    [self checkAndSendException];
}


+ (void)writeException:(NSString *)string {
    
    NSString *exceptionString = [NSString stringWithFormat:@"%@",string];
    
    NSString *folderPath = [self getExceptionStorePath];
    if (folderPath.length > 0) {
        NSString *sFile = [self getFullExceptionFileName];
        NSString *filePath = [folderPath stringByAppendingPathComponent:sFile];
        [exceptionString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

+ (void)checkAndSendException {
    
    //取最新一个日志文件
    NSArray* arrCrashFiles = [self getAllUnuploadedCrashFiles];
    if (arrCrashFiles.count <= 0)
    {
        NSLog(@"没有需要上传的崩溃日志文件");
        return;
    }
    
    NSString* sLastCrashFile = arrCrashFiles.lastObject;
    NSString* excpDir = [self getExceptionStorePath];
    NSString* filePath = [excpDir stringByAppendingPathComponent:sLastCrashFile];
    NSError *error;
    NSString *dataString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error){
        NSLog(@"读取崩溃日志文件内容时失败。文件名：%@， 原因：%@", sLastCrashFile, error.localizedDescription);
        return;
    }
    //调用接口上传
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        NSLog(@"测试上传文件");
        //记录上传成功的时间
        NSTimeInterval fTime = [[NSDate date] timeIntervalSince1970];
        [[NSUserDefaults standardUserDefaults] setDouble:fTime forKey:kCrashFileUploadedTime];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //移到成功目录
        [self moveCrashFileToUploadedDir:sLastCrashFile];
        //检测成功目录中的崩溃日志文件，过多就要删除
        [self restrictExeceptionFileCount];
    
    });

    
}


//构造Crash文件 完整路径
+ (NSString*) getFullExceptionFileName {
    //NoUpload_Excetipion_2016-10-10_12-00-32.txt
    NSString* sFileName = [NSString stringWithFormat:@"%@%@_%@.txt",
                           FilePrex,
                           ExceptionFileName,
                           [self getTimeStr]
                           ];
    return sFileName;
}

+ (NSString *)getTimeStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss.SSS"];
    return [dateFormatter stringFromDate:[NSDate date]];
}


+ (NSString *)getExceptionStorePath {
    NSString *documentsPath = [AWUncaughtExceptionHandler getDocumentPath];
    NSString *exceptionPath = [documentsPath stringByAppendingPathComponent:@"Exception"];
    if ([AWUncaughtExceptionHandler assurePathExisted:exceptionPath]){
        return exceptionPath;
    }
    else {
        NSLog(@"崩溃日志文件目录创建失败！");
        return nil;
    }
}


//Doucment
+ (NSString *)getDocumentPath {
    NSString* sHomeDir = NSHomeDirectory();
    NSString* logDataPath = [sHomeDir stringByAppendingPathComponent:@"Documents"];
    return logDataPath;
}

+ (NSString *)getCrashFilesUpladedStorePath {
    NSString *exceptionPath = [self getExceptionStorePath];
    if (!exceptionPath) {
        return nil;
    }
    
    NSString *exceptionUpladedPath = [exceptionPath stringByAppendingPathComponent:@"Uploaded"];
    if ([AWUncaughtExceptionHandler assurePathExisted:exceptionUpladedPath]) {
        return exceptionUpladedPath;
    }
    else {
        NSLog(@"崩溃日志文件上传目录创建失败！");
        return nil;
    }
}


+(BOOL) assurePathExisted:(NSString*)sPath {
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:sPath isDirectory:&isDir]) {
        return YES;
    }
    else {
        if ([sPath length] <= 0) {
            return NO;
        }
        BOOL bResult = [[NSFileManager defaultManager] createDirectoryAtPath:sPath
                                                 withIntermediateDirectories:YES
                                                                  attributes:nil
                                                                       error:nil];
        if (!bResult) {
            NSLog(@"创建目录失败：%@", sPath);
        }
        return bResult;
    }
}

//文件不能太多
+ (BOOL) restrictExeceptionFileCount {
    //崩溃日志目录检查
    NSString* exceptionPath = [self getCrashFilesUpladedStorePath];
    if (!exceptionPath) {
        return YES;
    }
    //取得崩溃文件列表
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError* err = nil;
    NSArray *arrFiles = [fileMgr contentsOfDirectoryAtPath:exceptionPath error:&err];
    if (!arrFiles || err != nil) {
        if (err) {
            NSLog(@"遍历目录失败：%@", err.localizedDescription);
        }
        return NO;
    }
    //排序
    NSArray *arrSortedFiles = [arrFiles sortedArrayUsingComparator:^(NSString* file1, NSString* file2)
                               {
                                   return [file1 compare:file2 options:NSNumericSearch];
                               }];
    
    BOOL bRes = YES;
    NSUInteger nShouldRemoveCount = arrSortedFiles.count > MaxCountOfUploadedCrashFile ? (arrSortedFiles.count - MaxCountOfUploadedCrashFile) : 0;
    for (NSUInteger i = 0; i < nShouldRemoveCount; i ++) {
        NSString* file = [arrSortedFiles firstObject];
        NSString *filepath = [exceptionPath stringByAppendingPathComponent:file];
        
        NSError* err = nil;
        bRes &= [fileMgr removeItemAtPath:filepath error:&err];
        if (err) {
            NSLog(@"删除旧崩溃日志文件失败：%@", err.localizedDescription);
        }
    }
    
    return bRes;
}

//获取未上传文件列表，并排好序
+ (NSArray*) getAllUnuploadedCrashFiles {
    NSMutableArray* arrRes = [NSMutableArray array];
    //崩溃日志目录检查
    NSString* exceptionPath = [self getExceptionStorePath];
    if (!exceptionPath) {
        return arrRes;
    }
    
    //取得崩溃文件列表
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError* err = nil;
    NSArray *arrFiles = [fileMgr contentsOfDirectoryAtPath:exceptionPath error:&err];
    if (!arrFiles || err != nil) {
        if (err) {
            NSLog(@"遍历目录失败：%@", err.localizedDescription);
        }
        return arrRes;
    }
    
    //遍历未上传崩溃文件
    NSMutableArray* arrUnuploadFiles = [NSMutableArray array];
    for (NSString* sFile in arrFiles) {
        //过滤子目录
        BOOL isDir;
        NSString* sFilePath = [exceptionPath stringByAppendingPathComponent:sFile];
        if ([fileMgr fileExistsAtPath:sFilePath isDirectory:&isDir] && isDir) {
            continue;
        }
        
        //匹配”NoUpload_“前缀
        NSRange rng = [sFile rangeOfString:FilePrex];
        if (rng.location == 0 && rng.length != NSNotFound) {
            [arrUnuploadFiles addObject:sFile];
        }
        else {
            //上传过的，全部移到已经上传目录
            rng = [sFile rangeOfString:ExceptionFileName];
            if (rng.location == 0 && rng.length != NSNotFound) {
                [self moveCrashFileToUploadedDir:sFile];
            }
        }
    }
    //排序
    NSArray *arrSortedFiles = [arrUnuploadFiles sortedArrayUsingComparator:^(NSString* file1, NSString* file2){
        //改成按名称中的时间排序
        return [file1 compare:file2 options:NSNumericSearch];
    }];
    [arrRes addObjectsFromArray:arrSortedFiles];
    return arrRes;
}

//将崩溃文件移到已上传目录
+(BOOL) moveCrashFileToUploadedDir:(NSString*)sFile {
    //匹配”NoUpload_“前缀
    NSString* sNewFile = sFile;
    NSRange rng = [sFile rangeOfString:FilePrex];
    if (rng.location == 0 && rng.length != NSNotFound) {
        NSUInteger fromIdx = rng.location + rng.length;
        sNewFile = [sFile substringFromIndex:fromIdx];
    }
    
    //移到已经上传目录
    BOOL bRes = NO;
    rng = [sNewFile rangeOfString:ExceptionFileName];
    if (rng.location == 0 && rng.length != NSNotFound) {
        //崩溃日志目录检查
        NSString* exceptionPath = [self getExceptionStorePath];
        NSString* uploadPath = [self getCrashFilesUpladedStorePath];
        
        NSString* thisFilePath = [exceptionPath stringByAppendingPathComponent:sFile];
        NSString *newFilePath = [uploadPath stringByAppendingPathComponent:sNewFile];
        
        NSError* errMove = nil;
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        bRes = [fileMgr moveItemAtPath:thisFilePath toPath:newFilePath error:&errMove];
        if(errMove) {
            NSLog(@"移动崩溃日志文件失败：file=%@", sFile);
        }
    }
    
    return bRes;
}

@end

