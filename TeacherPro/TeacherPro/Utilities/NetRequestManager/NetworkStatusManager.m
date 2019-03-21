//
//  NetworkStatusManager.m
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "NetworkStatusManager.h"


//static AFNetworkReachabilityStatus staticCurrentNetworkStatus; // 当前网络连接
static AFNetworkReachabilityManager *manager;            // 检测网络实例需要强引用

@interface NetworkStatusManager ()
@end

@implementation NetworkStatusManager
+ (void )startNetworkStatus
{
    manager = [AFNetworkReachabilityManager sharedManager];
    //要监控网络连接状态，必须要先调用单例的startMonitoring方法
    [manager startMonitoring];

    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // 当网络状态改变时调用
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
        }
//        [self updateInterfaceWithReachability:status];
        
    }];
   
 
}
// 处理连接改变后的情况
//+ (void)updateInterfaceWithReachability:(AFNetworkReachabilityStatus )status
//{
//    staticCurrentNetworkStatus =   status;
//}


+ (AFNetworkReachabilityStatus )getNetworkStatus
{
    return manager.networkReachabilityStatus;
}
+ (BOOL)isConnectNetwork
{
    return  manager.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
//    return staticCurrentNetworkStatus != AFNetworkReachabilityStatusNotReachable ;
}

+ (BOOL)isEnableWWAN
{
    return manager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN;
}

+ (BOOL)isEnableWIFI
{
    return manager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi;
}

@end
