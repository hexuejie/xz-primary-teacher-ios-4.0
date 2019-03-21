//
//  NetworkStatusManager.h
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworkReachabilityManager.h"
@interface NetworkStatusManager : NSObject
/**
 * 方法描述: 开启网络状态监听
 * 输入参数: 无
 * 返回值:  无
 * 创建人: DCQ
 */
+ (void )startNetworkStatus;
/**
 @ 方法描述    是否链接网络
 @ 输入参数    无
 @ 返回值      BOOL
 @ 创建人      DCQ
 */
+ (BOOL)isConnectNetwork;

/**
 @ 方法描述    是否3G/2G
 @ 输入参数    无
 @ 返回值      BOOL
 @ 创建人      DCQ
 */
+ (BOOL)isEnableWWAN;

/**
 @ 方法描述    是否WIFI
 @ 输入参数    无
 @ 返回值      BOOL
 @ 创建人      DCQ
 */
+ (BOOL)isEnableWIFI;
@end
