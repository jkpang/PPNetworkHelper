![image](https://github.com/jkpang/PPNetworkHelper/blob/master/Picture/PPNetworkHelper.png)

![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg) ![](https://img.shields.io/badge/pod-v0.7.0-blue.svg) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg)  [![](https://img.shields.io/badge/weibo-%40CoderPang-yellow.svg)](http://weibo.com/5743737098/profile?rightmod=1&wvr=6&mod=personinfo&is_all=1)

对AFNetworking 3.x 与YYCache的二次封装,封装常见的GET、POST、文件上传/下载、网络状态监测的功能、方法接口简洁明了,并结合YYCache实现对网络数据的缓存,简单易用,不用再写FMDB那烦人的SQL语句,一句代码搞定网络数据的请求与缓存. 
无需设置,无需插件,控制台可直接打印json中文字符,调试更方便

###新建 PP-iOS学习交流群 : 323408051 有关于PP系列封装的问题和iOS技术可以在此群讨论

[简书地址](http://www.jianshu.com/p/c695d20d95cb) ;

![image](https://github.com/jkpang/PPNetworkHelper/blob/master/Picture/network.gif)

##Requirements 要求
* iOS 7+
* Xcode 8+

##Installation 安装
###1.手动安装:
`下载DEMO后,将子文件夹PPNetworkHelper拖入到项目中, 导入头文件PPNetworkHelper.h开始使用`
###2.CocoaPods安装:
first
`pod 'PPNetworkHelper',:git => 'https://github.com/jkpang/PPNetworkHelper.git'`
then
`pod install或pod install --no-repo-update`

如果发现pod search PPNetworkHelper 不是最新版本，在终端执行pod setup命令更新本地spec镜像缓存(时间可能有点长),重新搜索就OK了
##Usage 使用方法
###1. 无自动缓存(GET与POST请求用法相同)
####1.1 无缓存
```objc
[PPNetworkHelper GET:url parameters:nil success:^(id responseObject) {
        //请求成功
    } failure:^(NSError *error) {
        //请求失败
}];
```
####1.2 无缓存,手动缓存

```objc
[PPNetworkHelper GET:url parameters:nil success:^(id responseObject) {
    //请求成功
        //手动缓存
    [PPNetworkCache setHttpCache:responseObject URL:url parameters:parameters];
    } failure:^(NSError *error) {
    //请求失败
}];
```
###2. 自动缓存(GET与POST请求用法相同)

```objc
[PPNetworkHelper GET:url parameters:nil responseCache:^(id responseCache) {
        //加载缓存数据
    } success:^(id responseObject) {
        //请求成功
    } failure:^(NSError *error) {
        //请求失败
}];
```
###3.单/多图片上传

```objc
[PPNetworkHelper uploadImagesWithURL:url
                    	parameters:@{@"参数":@"参数"}
                        	images:@[@"UIImage数组"]
                          name:@"文件对应服务器上的字段"
                      fileNames:@"文件名称数组"
                      imageType:@"图片的类型,png,jpeg" 
                      imageScale:@"图片文件压缩比 范围 (0.f ~ 1.f)"
                      progress:^(NSProgress *progress) {
                          //上传进度
                          NSLog(@"上传进度:%.2f%%",100.0 * progress.completedUnitCount/progress.totalUnitCount);
                      } success:^(id responseObject) {
                         //上传成功
                      } failure:^(NSError *error) {
                        //上传失败
}];

```
###4.文件上传
```objc
[PPNetworkHelper uploadFileWithURL:url
                    parameters:@{@"参数":@"参数"}
                          name:@"文件对应服务器上的字段"
                      filePath:@"文件本地的沙盒路径"
                      progress:^(NSProgress *progress) {
                          //上传进度
                          NSLog(@"上传进度:%.2f%%",100.0 * progress.completedUnitCount/progress.totalUnitCount);
                      } success:^(id responseObject) {
                         //上传成功
                      } failure:^(NSError *error) {
                        //上传失败
}];

```
###5.文件下载

```objc
NSURLSessionTask *task = [PPNetworkHelper downloadWithURL:url fileDir:@"下载至沙盒中的制定文件夹(默认为Download)" progress:^(NSProgress *progress) {
        //下载进度,如果要配合UI进度条显示,必须在主线程更新UI
        NSLog(@"下载进度:%.2f%%",100.0 * progress.completedUnitCount/progress.totalUnitCount);
    } success:^(NSString *filePath) {
        //下载成功
    } failure:^(NSError *error) {
        //下载失败
}];
    
//暂停下载,暂不支持断点下载
[task suspend];
//开始下载
[task resume];
```
###6.网络状态监测

```objc
    
    // 1.实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
    [PPNetworkHelper networkStatusWithBlock:^(PPNetworkStatus status) {
        switch (status) {
            case PPNetworkStatusUnknown:          //未知网络
                break;
            case PPNetworkStatusNotReachable:    //无网络
                break;
            case PPNetworkStatusReachableViaWWAN://手机网络
                break;
            case PPNetworkStatusReachableViaWiFi://WIFI
                break;
        }
    }];
    
    // 2.一次性获取当前网络状态
    if (kIsNetwork) {          
        NSLog(@"有网络");
        if (kIsWWANNetwork) {                    
            NSLog(@"手机网络");
        }else if (kIsWiFiNetwork){
            NSLog(@"WiFi网络");
        }
    }
    或
    if ([PPNetworkHelper isNetwork]) {
        NSLog(@"有网络");
        if ([PPNetworkHelper isWWANNetwork]) {
            NSLog(@"手机网络");
        }else if ([PPNetworkHelper isWiFiNetwork]){
            NSLog(@"WiFi网络");
        }
    }
```
###7. 网络缓存
####7.1 获取缓存总大小
```objc
NSInteger totalBytes = [PPNetworkCache getAllHttpCacheSize];
NSLog(@"网络缓存大小cache = %.2fMB",totalBytes/1024/1024.f);
```
####7.2 删除所有缓存

```objc
[PPNetworkCache removeAllHttpCache];
```
###8.网络参数设置(附说明)

```objc
/*
 **************************************  说明  **********************************************
 *
 * 在一开始设计接口的时候就想着方法接口越少越好,越简单越好,只有GET,POST,上传,下载,监测网络状态就够了.
 *
 * 无奈的是在实际开发中,每个APP与后台服务器的数据交互都有不同的请求格式,如果要修改请求格式,就要在此封装
 * 内修改,再加上此封装在支持CocoaPods后,如果使用者pod update最新PPNetworkHelper,那又要重新修改此
 * 封装内的相关参数.
 *
 * 依个人经验,在项目的开发中,一般都会将网络请求部分封装 2~3 层,第2层配置好网络请求工具的在本项目中的各项
 * 参数,其暴露出的方法接口只需留出请求URL与参数的入口就行,第3层就是对整个项目请求API的封装,其对外暴露出的
 * 的方法接口只留出请求参数的入口.这样如果以后项目要更换网络请求库或者修改请求URL,在单个文件内完成配置就好
 * 了,大大降低了项目的后期维护难度
 *
 * 综上所述,最终还是将设置参数的接口暴露出来,如果通过CocoaPods方式使用PPNetworkHelper,在设置项目网络
 * 请求参数的时候,强烈建议开发者在此基础上再封装一层,通过以下方法配置好各种参数与请求的URL,便于维护
 *
 **************************************  说明  **********************************************
 */

#pragma mark - 重置AFHTTPSessionManager相关属性
/**
 *  设置网络请求参数的格式:默认为二进制格式
 *
 *  @param requestSerializer PPRequestSerializerJSON(JSON格式),PPRequestSerializerHTTP(二进制格式),
 */
+ (void)setRequestSerializer:(PPRequestSerializer)requestSerializer;

/**
 *  设置服务器响应数据格式:默认为JSON格式
 *
 *  @param responseSerializer PPResponseSerializerJSON(JSON格式),PPResponseSerializerHTTP(二进制格式)
 */
+ (void)setResponseSerializer:(PPResponseSerializer)responseSerializer;

/**
 *  设置请求超时时间:默认为30S
 *
 *  @param time 时长
 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

/**
 *  设置请求头
 */
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/**
 *  是否打开网络状态转圈菊花:默认打开
 *
 *  @param open YES(打开), NO(关闭)
 */
+ (void)openNetworkActivityIndicator:(BOOL)open;

/**
 配置自建证书的Https请求, 参考链接: http://blog.csdn.net/syg90178aw/article/details/52839103

 @param cerPath 自建Https证书的路径
 @param validatesDomainName 是否需要验证域名，默认为YES. 如果证书的域名与请求的域名不一致，需设置为NO; 即服务器使用其他可信任机构颁发
        的证书，也可以建立连接，这个非常危险, 建议打开.validatesDomainName=NO, 主要用于这种情况:客户端请求的是子域名, 而证书上的是另外
        一个域名。因为SSL证书上的域名是独立的,假如证书上注册的域名是www.google.com, 那么mail.google.com是无法验证通过的.
 */
+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName;
```

PPNetworkHelper全部以类方法调用,使用简单,麻麻再也不用担心我一句一句地写SQLite啦~~~如果你有更好的建议,希望不吝赐教!
###你的star是我持续更新的动力!
===
##CocoaPods更新日志
* **2017.02.15(tag:0.7.0):** 
	 1. 新增 日志打印打开/关闭接口;
	 2. 修复 单/多图上传BUG;
	 3. 优化代码规范;
* **2017.02.06(tag:0.6.0):** 
	 1. 重构 "单/多图片上传"部分;
	 2. 新增 "上传文件接口"
* **2017.01.02(tag:0.5.0):** 
    1. 添加配置自建证书的Https请求的接口;
    2. 修复一次性网络判断需要先调网络监测方法才能生效的BUG, 现在可直接调用一次性网络判断即可生效!
    3. 修改在POST请求时,请求参数的默认格式二进制(之前是JSON格式),**注意,如果有同学在升级此版本后导致获取不到服务器数据,请将设置请求参数格式的代码注释掉即可!**
    4. 将NetworkStatu-->PPNetworkStatus, 避免与其他第三方库产生冲突!
    5. 修改缓存的读取为异步读取,不会阻塞主线程;
    6. 其他一些代码优化与修改.
* **2016.11.22(tag:0.4.0):**
    1. 一次性判断当前网络状态值更加准确;
    2. 添加手机网络,WiFi的当前网络状态
* **2016.11.18(tag:0.3.1):** 
    1. 新增取消所有http请求;
    2. 新增取消指定URL请求 的方法
* **2016.09.26(tag:0.3.0)--**控制台直接打印json中文字符,无需插件
* **2016.09.18(tag:0.2.5)--**1.支持单个页面的多级数据缓存,2.简化网络状态监测的方法调用
* **2016.09.12(tag:0.2.1)--**小细节优化
* **2016.09.10(tag:0.2.0)--**增加网络请求设置接口(详情见:7.网络参数设置)
* **2016.09.06(tag:0.1.2)--**修复在无网络进行下载时,会触发下载成功回调的Bug.
* **2016.09.05(tag:0.1.1)--**多个请求的情况下采取一个共享的AFHTTPSessionManager;
* **2016.08.26(tag:0.1.0)--**初始化到CocoaPods;

##联系方式:
* Weibo : @CoderPang
* Email : jkpang@outlook.com
* QQ群 : 323408051

![PP-iOS学习交流群群二维码](https://github.com/jkpang/PPCounter/blob/master/PP-iOS%E5%AD%A6%E4%B9%A0%E4%BA%A4%E6%B5%81%E7%BE%A4%E7%BE%A4%E4%BA%8C%E7%BB%B4%E7%A0%81.png)

##许可证
PPNetworkHelper 使用 MIT 许可证，详情见 LICENSE 文件。

