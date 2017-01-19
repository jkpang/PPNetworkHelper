//
//  ViewController.m
//  PPNetworkHelper
//
//  Created by AndyPang on 16/8/12.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

/*
 *********************************************************************************
 *
 *⭐️⭐️⭐️ 新建 PP-iOS学习交流群: 323408051 欢迎加入!!! ⭐️⭐️⭐️
 *
 * 如果您在使用 PPNetworkHelper 的过程中出现bug或有更好的建议,还请及时以下列方式联系我,我会及
 * 时修复bug,解决问题.
 *
 * Weibo : CoderPang
 * Email : jkpang@outlook.com
 * QQ 群 : 323408051
 * GitHub: https://github.com/jkpang
 *
 * PS:我的另外两个很好用的封装,欢迎使用!
 * 1.一行代码获取通讯录联系人,并进行A~Z精准排序(已处理姓名所有字符的排序问题):
 *   GitHub:https://github.com/jkpang/PPGetAddressBook
 * 2.iOS中一款高度可定制性商品计数按钮(京东/淘宝/饿了么/美团外卖/百度外卖样式):
 *   GitHub:https://github.com/jkpang/PPNumberButton
 *
 * 如果 PPGetAddressBookSwift 好用,希望您能Star支持,你的 ⭐️ 是我持续更新的动力!
 *********************************************************************************
 */

#import "ViewController.h"
#import "PPNetworkHelper.h"


static NSString *const dataUrl = @"http://www.qinto.com/wap/index.php?ctl=article_cate&act=api_app_getarticle_cate&num=1&p=1";
static NSString *const downloadUrl = @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *networkData;
@property (weak, nonatomic) IBOutlet UITextView *cacheData;
@property (weak, nonatomic) IBOutlet UILabel *cacheStatus;
@property (weak, nonatomic) IBOutlet UISwitch *cacheSwitch;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

/** 是否开启缓存*/
@property (nonatomic, assign, getter=isCache) BOOL cache;

/** 是否开始下载*/
@property (nonatomic, assign, getter=isDownload) BOOL download;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"网络缓存大小cache = %fMB",[PPNetworkCache getAllHttpCacheSize]/1024/1024.f);
    /*添加请求头在项目中*/
    NSLog(@"网络缓存大小cache = %fMB",[PPNetworkCache getAllHttpCacheSize]/1024/1024.f);
    
    
    //实时监测网络状态
    [PPNetworkHelper networkStatusWithBlock:^(PPNetworkStatusType networkStatus) {
        
        switch (networkStatus) {
            case PPNetworkStatusUnknown:
            case PPNetworkStatusNotReachable: {
                self.networkData.text = @"没有网络";
                
                [self getData:YES url:dataUrl];
                
                NSLog(@"无网络,加载缓存数据");
                break;
            }
            case PPNetworkStatusReachableViaWWAN:
            case PPNetworkStatusReachableViaWiFi: {
                [self getData:[[NSUserDefaults standardUserDefaults] boolForKey:@"isOn"] url:dataUrl];
                NSLog(@"有网络,请求网络数据");
                break;
            }
        }

    }];
    
    // 一次性获取当前网络状态
    [self currentNetworkStatus];

}

#pragma  mark - 获取数据
- (void)getData:(BOOL)isOn url:(NSString *)url
{

    //自动缓存
    if(isOn)
    {
        self.cacheStatus.text = @"缓存打开";
        self.cacheSwitch.on = YES;
        [PPNetworkHelper GET:url parameters:nil responseCache:^(id responseCache) {
            
            self.cacheData.text = [self jsonToString:responseCache];
            
        } success:^(id responseObject) {
            
            self.networkData.text = [self jsonToString:responseObject];
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    //无缓存
    else
    {
        self.cacheStatus.text = @"缓存关闭";
        self.cacheSwitch.on = NO;
        self.cacheData.text = @"";
        
        [PPNetworkHelper GET:url parameters:nil success:^(id responseObject) {
            
            self.networkData.text = [self jsonToString:responseObject];
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    
}

#pragma mark - 一次性网络状态判断
- (void)currentNetworkStatus
{
    if (kIsNetwork) {
        NSLog(@"有网络");
        if (kIsWWANNetwork) {
            NSLog(@"手机网络");
        }else if (kIsWiFiNetwork){
            NSLog(@"WiFi网络");
        }
    }
    // 或
//    if ([PPNetworkHelper isNetwork]) {
//        NSLog(@"有网络");
//        if ([PPNetworkHelper isWWANNetwork]) {
//            NSLog(@"手机网络");
//        }else if ([PPNetworkHelper isWiFiNetwork]){
//            NSLog(@"WiFi网络");
//        }
//    }
}

#pragma mark - 下载

- (IBAction)download:(UIButton *)sender {
    
    static NSURLSessionTask *task = nil;
    //开始下载
    if(!self.isDownload)
    {
        self.download = YES;
        [self.downloadBtn setTitle:@"取消下载" forState:UIControlStateNormal];
        
        task = [PPNetworkHelper downloadWithURL:downloadUrl fileDir:@"Download" progress:^(NSProgress *progress) {
            
            CGFloat stauts = 100.f * progress.completedUnitCount/progress.totalUnitCount;
            self.progress.progress = stauts/100.f;
            
            NSLog(@"下载进度 :%.2f%%,,%@",stauts,[NSThread currentThread]);
        } success:^(NSString *filePath) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"下载完成!"
                                                                message:[NSString stringWithFormat:@"文件路径:%@",filePath]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            [self.downloadBtn setTitle:@"重新下载" forState:UIControlStateNormal];
            NSLog(@"filePath = %@",filePath);
            
        } failure:^(NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"下载失败"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            NSLog(@"error = %@",error);
        }];

    }
    //暂停下载
    else
    {
        self.download = NO;
        [task suspend];
        self.progress.progress = 0;
        [self.downloadBtn setTitle:@"开始下载" forState:UIControlStateNormal];
    }
    
    
    
}

#pragma mark - 缓存开关
- (IBAction)isCache:(UISwitch *)sender {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:sender.isOn forKey:@"isOn"];
    [userDefault synchronize];
    
    [self getData:sender.isOn url:dataUrl];
}

/**
 *  json转字符串
 */
- (NSString *)jsonToString:(NSDictionary *)dic
{
    if(!dic){
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@"%@",jsonData);
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
