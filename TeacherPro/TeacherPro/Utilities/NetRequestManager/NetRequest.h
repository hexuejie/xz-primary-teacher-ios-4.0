//
//  NetRequest.h
//  TeacherPro
//
//  Created by DCQ on 2017/4/27.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
// GET / POST / PUT / DELETE (default is GET)
# define RequestMethodType_GET      @"GET"
# define RequestMethodType_POST     @"POST"
# define RequestMethodType_PUT      @"PUT"
# define RequestMethodType_DELETE   @"DELETE"
# define RequestMethodType_DOWNLOAD @"DOWNLOAD"
# define RequestMethodType_UPLOADIMG   @"UPLOADIMG"
# define RequestMethodType_UPLOADAUDIO    @"UPLOADAUDIO"
// 自定义业务状态码
/**
 @ 1200	操作成功(查询成功,修改成功,新增成功,删除成功)
 @ 1404	资源无法找到
 @ 1500	内部错误
 @ 1600	参数不合法
 
 @ 8034 用户凭证过期
 @ 8005 用户凭证不完整
 @ 8006 非法的用户凭证
 */
typedef NS_ENUM (NSInteger, MyAFHTTPCodeType)
{
    MyHTTPCodeType_Success                  = 1,
    
    MyHTTPCodeType_DataSourceNotFound       = 1404,
    MyHTTPCodeType_InternalError            = 1500,
    MyHTTPCodeType_IllegalParameter         = 1600,
    
    MyHTTPCodeType_TokenOverdue             = -100,
    MyHTTPCodeType_TokenIncomplete          = 8005,
    MyHTTPCodeType_TokenIllegal             = 8006,
    MyHTTPCodeType_NoLogin                  = -100,
    MyHTTPCodeType_ConnectionFailed         = 404,
    MyHTTPCodeType_NoUser                   = -102,
    MyHTTPCodeType_NoStudent                = -101
};
@protocol NetRequestDelegate;

typedef NS_ENUM(NSInteger,NetCachePolicy)
{
    /// 如果存在缓存且没有过期则使用缓存数据,否则重新向服务器发送请求
    NetAskServerIfModifiedWhenStaleCachePolicy = 0,
    
    /// 无视缓存数据,总是向服务器请求新的数据
    NetAlwaysAskServerCachePolicy,
    
    /// 不做数据缓存
    NetNotCachePolicy
    
}; /// 缓存策略

extern NSString * const cacheKey  ;
extern NSString * const cacheExpiresInSecondsKey  ;
@interface NetRequest : NSObject
{
    AFHTTPSessionManager *_manager;
    
}
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) NSURLSessionDataTask *task;
// 下载操作
@property (nonatomic,strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic,assign) int tag;
@property (nonatomic,strong) NSDictionary *userInfo;
@property (nonatomic,weak) id<NetRequestDelegate>delegate;
@property (nonatomic,strong) id resultInfoObj;
@property (nonatomic,strong) NSError *resultErorr;
/// 是否使用的缓存数据
@property (nonatomic,assign) BOOL didUseCachedResponse;
/// 请求url
@property (nonatomic,strong) NSURL * url;
///get post 请求类型
@property (nonatomic,strong) NSString *methodType;
///请求参数
@property (nonatomic,strong) NSDictionary *parameterDic;

//上传文件路径
@property (nonatomic,strong) NSDictionary *fileDic;

- (void)starRequest;
@end

@protocol NetRequestDelegate <NSObject>

@optional
- (void)netRequest:(NetRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders;
- (void)netRequestDidStarted:(NetRequest *)request;
- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj;
- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error;
//上传文件开始
- (void)netRequestDidStartedUpload:(NetRequest *)request;
//文件进度
- (void)netRequest:(NetRequest *)request setProgress:(float)newProgress;
//下载文件开始
- (void)netRequestDidStartedDownload:(NetRequest *)request;

@end
