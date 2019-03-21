//
//  UrlManager.h
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlManager : NSObject
/**
 * 方法描述: 获得服务器请求域名
 * 输入参数: 无
 * 返回值: NSString
 * 创建人:   DCQ
 */
+ (NSString *)getRequestNameSpace;

/**
 * 方法描述: 获得服务器图片域名
 * 输入参数: 无
 * 返回值: NSString
 * 创建人:  DCQ
 */
+ (NSString *)getImageNameSpace;

/**
 * 方法描述: 获得服务器请求URL地址
 * 输入参数: 请求方法
 * 返回值: NSURL
 * 创建人:  DCQ
 */
+ (NSURL *)getRequestUrlByMethodName:(NSString *)methodName;

/**
 @ 方法描述    获得GET方式请求的URL地址
 @ 输入参数    methodName: 请求方法名 argsDic: 拼装在URL里的参数(以键值对方式传入)
 @ 返回值      NSURL
 @ 创建人      DCQ
 */
+ (NSURL *)getRequestUrlByMethodName:(NSString *)methodName andArgsDic:(NSDictionary *)dic;


/**
 @ 方法描述    获得GET方式请求的URL地址
 
 @ 输入参数    methodName: 请求方法名 ArgsStr: 字符串直接拼接到url后面
 
 @ 返回值      NSURL 参数直接拼接在url后面
 
 @ 创建人      DCQ
 */
+ (NSURL *)getRequestUrlByMethodName:(NSString *)methodName andArgsDicStr:(NSDictionary *)dic;

@end
