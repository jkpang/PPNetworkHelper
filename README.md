# PPNetworkHelper

对AFNetworking 3.x 与YYCache的二次封装,封装常见的GET、POST、文件上传/下载、网络状态监测的功能、方法接口简洁明了,并结合YYCache实现对网络数据的缓存,简单易用,不用再写FMDB那烦人的SQL语句,一句代码搞定网络数据的请求与缓存. ( 注:如果更新pod出错,请升级cocoaPods版本到1.x或者修改podfile文件的内容格式重新pod)

![image](https://github.com/jkpang/PPNetworkHelper/blob/master/Picture/network.gif)
##一、PPNetworkHelper,网络请求部分,对AFN3.x的简单封装
###1.GET请求-无缓存

```objc
/**
 *  GET请求,无缓存
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancle方法
 */
+ (__kindof NSURLSessionTask *)GET:(NSString *)URL parameters:(NSDictionary *)parameters success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

```
###2.GET请求-自动缓存

```objc
/**
 *  GET请求,自动缓存
 *
 *  @param URL           请求地址
 *  @param parameters    请求参数
 *  @param responseCache 缓存数据的回调
 *  @param success       请求成功的回调
 *  @param failure       请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancle方法
 */
+ (__kindof NSURLSessionTask *)GET:(NSString *)URL parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;
```
###3.POST请求-无缓存

```objc
/**
 *  POST请求,无缓存
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancle方法
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL parameters:(NSDictionary *)parameters success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;
```
###4.POST请求自动缓存

```objc
/**
 *  POST请求,自动缓存
 *
 *  @param URL           请求地址
 *  @param parameters    请求参数
 *  @param responseCache 缓存数据的回调
 *  @param success       请求成功的回调
 *  @param failure       请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancle方法
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;
```
###5.上传图片文件

```objc
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
 *  @return 返回的对象可取消请求,调用cancle方法
 */
+ (__kindof NSURLSessionTask *)uploadWithURL:(NSString *)URL parameters:(NSDictionary *)parameters images:(NSArray<UIImage *> *)images name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(HttpProgress)progress success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;
```
###6.下载文件

```objc
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
+ (__kindof NSURLSessionTask *)downloadWithURL:(NSString *)URL fileDir:(NSString *)fileDir progress:(HttpProgress)progress success:(void(^)(NSString *filePat
+ h))success failure:(HttpRequestFailed)failure;
```
###7.监听网络状态及网络状态实时回调

```objc
/**
 *  开始监听网络状态
 */
+ (void)startMonitoringNetwork;

/**
 *  通过Block回调实时获取网络状态,也可以通过返回值进行一次性判断
 */
+ (BOOL)checkNetworkStatusWithBlock:(NetworkStatus)status;
```
##二、PPNetworkCache,数据缓存部分-对YYCache超简单封装(简单到不能叫封装吧)

```objc
/**
 *  缓存网络数据
 *
 *  @param responseCache 服务器返回的数据
 *  @param key           缓存数据对应的key值,推荐填入请求的URL
 */
+ (void)saveHttpCache:(id)httpCache forKey:(NSString *)key;

/**
 *  取出缓存的数据
 *
 *  @param key 根据存入时候填入的key值来取出对应的数据
 *
 *  @return 缓存的数据
 */
+ (id)getHttpCacheForKey:(NSString *)key;

/**
 *  获取网络缓存的总大小 bytes(字节)
 */
+ (NSInteger)getAllHttpCacheSize;

/**
 *  删除所有网络缓存,
 */
+ (void)removeAllHttpCache;

```

##三、请求示例
###1.无缓存

```objc
[PPNetworkHelper GET:url parameters:nil success:^(id responseObject) {
           //请求成功
        } failure:^(NSError *error) {
            //请求失败
        }];
```
###2.自动缓存

```objc
[PPNetworkHelper GET:url parameters:nil responseCache:^(id responseCache) {
          //加载缓存数据
        } success:^(id responseObject) {
            //请求成功
        } failure:^(NSError *error) {
            //请求失败
        }];
```

以上就是对AFN3.x结合YYCache的简单封装,全部是类方法调用,使用简单,麻麻再也不用担心我一句一句地写SQLite啦~~~欢迎各路大神的批评指正以及建议.

##联系方式:
* Weibo : @CoderPang
* Email : jkpang@outlook.com
* QQ : 2406552315

##许可证
PPNetworkHelper 使用 MIT 许可证，详情见 LICENSE 文件。

