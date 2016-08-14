//
//  PPNetworkHelper.m
//  PPNetworkHelper
//
//  Created by AndyPang on 16/8/12.
//  Copyright © 2016年 AndyPang. All rights reserved.
//


#import "PPNetworkHelper.h"
#import "PPNetworkCache.h"
#import <AFNetworking.h>


#ifdef DEBUG
#define PPLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define PPLog(...)
#endif


@implementation PPNetworkHelper
static AFHTTPSessionManager *_manager;
static NetworkStatus _status;
static BOOL _isNetwork;

#pragma mark - 开始监听网络
+ (void)startMonitoringNetwork
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
                _status(PPNetworkStatusUnknown);
                _isNetwork = NO;
                PPLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                _status(PPNetworkStatusNotReachable);
                _isNetwork = NO;
                PPLog(@"无网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                _status(PPNetworkStatusReachableViaWWAN);
                _isNetwork = YES;
                PPLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                _status(PPNetworkStatusReachableViaWiFi);
                _isNetwork = YES;
                PPLog(@"WIFI");
                break;
        }
    }];
    [manager startMonitoring];
    
}

+ (BOOL)networkStatusWithBlock:(NetworkStatus)status
{
    status ? _status = status : nil;
    return _isNetwork;
}

#pragma mark - GET请求无缓存

+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(NSDictionary *)parameters
                  success:(HttpRequestSuccess)success
                  failure:(HttpRequestFailed)failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];
    return [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        success(responseObject);
        PPLog(@"responseObject = %@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        failure ? failure(error) : nil;
        PPLog(@"error = %@",error);
    }];
}

#pragma mark - GET请求自动缓存
+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(NSDictionary *)parameters
            responseCache:(HttpRequestCache)responseCache
                  success:(HttpRequestSuccess)success
                  failure:(HttpRequestFailed)failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //读取缓存
    responseCache([PPNetworkCache getResponseCacheForKey:URL]);
    
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];
    return [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        success(responseObject);
        //对数据进行异步缓存
        [PPNetworkCache saveResponseCache:responseObject forKey:URL];
        PPLog(@"responseObject = %@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        failure ? failure(error) : nil;
        PPLog(@"error = %@",error);
        
    }];
}

#pragma mark - POST请求无缓存
+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(NSDictionary *)parameters
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestFailed)failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];
    return [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        success(responseObject);
        PPLog(@"responseObject = %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        failure ? failure(error) : nil;
        PPLog(@"error = %@",error);
    }];
    
}

#pragma mark - POST请求自动缓存
+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(NSDictionary *)parameters
             responseCache:(HttpRequestCache)responseCache
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestFailed)failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //读取缓存
    responseCache([PPNetworkCache getResponseCacheForKey:URL]);
    
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];
    return [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        success(responseObject);
        //对数据进行异步缓存
        [PPNetworkCache saveResponseCache:responseObject forKey:URL];
        PPLog(@"responseObject = %@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        failure ? failure(error) : nil;
        PPLog(@"error = %@",error);
    }];
    
}

#pragma mark - 上传图片文件
+ (NSURLSessionTask *)uploadWithURL:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                             images:(NSArray<UIImage *> *)images
                               name:(NSString *)name
                           fileName:(NSString *)fileName
                           mimeType:(NSString *)mimeType
                           progress:(HttpProgress)progress
                            success:(HttpRequestSuccess)success
                            failure:(HttpRequestFailed)failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];
    return [manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //压缩-添加-上传图片
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            [formData appendPartWithFileData:imageData name:name fileName:[NSString stringWithFormat:@"%@%ld.%@",fileName,idx,mimeType?mimeType:@"jpeg"] mimeType:[NSString stringWithFormat:@"image/%@",mimeType?mimeType:@"jpeg"]];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        progress ? progress(uploadProgress) : nil;
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        success(responseObject);
        PPLog(@"responseObject = %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        failure ? failure(error) : nil;
        PPLog(@"error = %@",error);
    }];
}

#pragma mark - 下载文件
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(HttpProgress)progress
                              success:(void(^)(NSString *))success
                              failure:(HttpRequestFailed)failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        progress ? progress(downloadProgress) : nil;
        PPLog(@"下载进度:%.2f%%",100.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        
        PPLog(@"downloadDir = %@",downloadDir);
        
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        failure && error ? failure(error) : nil;
        
    }];
    
    //开始下载
    [downloadTask resume];
    
    return downloadTask;
    
}


#pragma mark - 设置AFHTTPSessionManager相关属性

+ (AFHTTPSessionManager *)createAFHTTPSessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求参数的类型:HTTP (AFJSONRequestSerializer,AFHTTPRequestSerializer)
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //设置请求的超时时间
    manager.requestSerializer.timeoutInterval = 30.f;
    //设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    return manager;
}


@end