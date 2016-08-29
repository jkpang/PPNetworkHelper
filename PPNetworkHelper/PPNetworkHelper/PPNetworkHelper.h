//
//  PPNetworkHelper.h
//  PPNetworkHelper
//
//  Created by AndyPang on 16/8/12.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PPNetworkCache.h"

typedef NS_ENUM(NSUInteger, PPNetworkStatus) {
    /** 未知网络*/
    PPNetworkStatusUnknown,
    /** 无网络*/
    PPNetworkStatusNotReachable,
    /** 手机网络*/
    PPNetworkStatusReachableViaWWAN,
    /** WIFI网络*/
    PPNetworkStatusReachableViaWiFi
};

/** 请求成功的Block */
typedef void(^HttpRequestSuccess)(id responseObject);

/** 请求失败的Block */
typedef void(^HttpRequestFailed)(NSError *error);

/** 缓存的Block */
typedef void(^HttpRequestCache)(id responseCache);

/** 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小*/
typedef void (^HttpProgress)(NSProgress *progress);

/** 网络状态的Block*/
typedef void(^NetworkStatus)(PPNetworkStatus status);



@interface PPNetworkHelper : NSObject

/**
 *  开始监听网络状态(此方法在整个项目中只需要调用一次)
 */
+ (void)startMonitoringNetwork;

/**
 *  通过Block回调实时获取网络状态
 */
+ (void)checkNetworkStatusWithBlock:(NetworkStatus)status;

/**
 *  获取当前网络状态,有网YES,无网:NO
 */
+ (BOOL)currentNetworkStatus;

/**
 *  GET请求,无缓存
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(NSDictionary *)parameters
                           success:(HttpRequestSuccess)success
                           failure:(HttpRequestFailed)failure;

/**
 *  GET请求,自动缓存
 *
 *  @param URL           请求地址
 *  @param parameters    请求参数
 *  @param responseCache 缓存数据的回调
 *  @param success       请求成功的回调
 *  @param failure       请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(NSDictionary *)parameters
                     responseCache:(HttpRequestCache)responseCache
                           success:(HttpRequestSuccess)success
                           failure:(HttpRequestFailed)failure;

/**
 *  POST请求,无缓存
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                            success:(HttpRequestSuccess)success
                            failure:(HttpRequestFailed)failure;

/**
 *  POST请求,自动缓存
 *
 *  @param URL           请求地址
 *  @param parameters    请求参数
 *  @param responseCache 缓存数据的回调
 *  @param success       请求成功的回调
 *  @param failure       请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                      responseCache:(HttpRequestCache)responseCache
                            success:(HttpRequestSuccess)success
                            failure:(HttpRequestFailed)failure;

/**
 *  上传图片文件
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param images     图片数组
 *  @param name       文件对应服务器上的字段
 *  @param fileName   文件名
 *  @param mimeType   图片文件的类型,例:png、jpeg(默认类型)....
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)uploadWithURL:(NSString *)URL
                                  parameters:(NSDictionary *)parameters
                                      images:(NSArray<UIImage *> *)images
                                        name:(NSString *)name
                                    fileName:(NSString *)fileName
                                    mimeType:(NSString *)mimeType
                                    progress:(HttpProgress)progress
                                     success:(HttpRequestSuccess)success
                                     failure:(HttpRequestFailed)failure;

/**
 *  下载文件
 *
 *  @param URL      请求地址
 *  @param fileDir  文件存储目录(默认存储目录为Download)
 *  @param progress 文件下载的进度信息
 *  @param success  下载成功的回调(回调参数filePath:文件的路径)
 *  @param failure  下载失败的回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
 */
+ (__kindof NSURLSessionTask *)downloadWithURL:(NSString *)URL
                                       fileDir:(NSString *)fileDir
                                      progress:(HttpProgress)progress
                                       success:(void(^)(NSString *filePath))success
                                       failure:(HttpRequestFailed)failure;


@end

