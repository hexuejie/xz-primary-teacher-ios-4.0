//
//  NetRequestManager.h
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequest.h"

#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef  DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
    static dispatch_once_t once; \
    static __class * __singleton__; \
    dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
    return __singleton__; \
}



@interface NetRequestManager : NSObject{

@private
    NSMutableArray *netRequestArray;
    
    BOOL networkDataIsJsonType;
}

AS_SINGLETON(NetRequestManager);

/**
 @ 方法描述    发送一个GET普通请求
 @ 输入参数    parameterDic: 参数字典,如是引用对象需转换成JSON格式的字符串 tag:请求方法     userInfo 用户信息
 @ 返回值      void
 @ 创建人      DCQ
 */
- (void)sendRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo;

/**
 @ 方法描述    发送一个请求
 @ 输入参数    parameterDic: 参数字典,如是引用对象需转换成JSON格式的字符串 methodType: HTTP请求方式  tag:请求方法     userInfo 用户信息
 @ 返回值      void
 @ 创建人      DCQ
 */
- (void)sendRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo;
/**
 @ 方法描述    发送一个请求
 @ 输入参数    parameterDic: 参数字典,如是引用对象需转换成JSON格式的字符串 headers:http头部添加数据 methodType: HTTP请求方式  tag:请求方法     userInfo 用户信息
 @ 返回值      void
 @ 创建人      DCQ
 */
- (void)sendRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo;


/**
 @ 方法描述    发送一个下载文件请求
 @ 输入参数    parameterDic: 参数字典,如是引用对象需转换成JSON格式的字符串 savePath: 文件保持路径 tempPath: 文件下载临时路径
 @ 返回值      void
 @ 创建人      DCQ
 */
- (void)sendDownloadRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate savePath:(NSString *)savePath tempPath:(NSString *)tempPath;

- (void)sendDownloadRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo savePath:(NSString *)savePath tempPath:(NSString *)tempPath;


/**
 @ 方法描述    发送一个上传文件的请求
 @ 输入参数    parameterDic: 参数字典,如是引用对象需转换成JSON格式的字符串 fileDic: 文件沙盒路径
 @ 返回值      void
 @ 创建人      DCQ
 */
- (void)sendUploadRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate fileDic:(NSDictionary *)fileDic;

- (void)sendUploadRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo fileDic:(NSDictionary *)fileDic;

- (void)startRequestWithUrl:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo savePath:(NSString *)savePath tempPath:(NSString *)tempPath fileDic:(NSDictionary *)fileDic netCachePolicy:(NetCachePolicy)cachePolicy cacheSeconds:(NSTimeInterval)cacheSeconds;

/// 发送最后一次的历史请求
- (void)sendLatestRequest;


- (void)removeRequest:(NetRequest *)request;

//指定下载文件请求暂停
- (void)downloadTaskPause:(NSInteger)tag;
//指定暂停下载文件的请求恢复下载
- (void)downloadTaskResume:(NSInteger)tag;
//指定取消下载文件请求
- (void)downloadTaskCancel:(NSInteger)tag;

- (void)clearDelegate:(id<NetRequestDelegate>)delegate;
@end



