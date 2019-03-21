//
//  NetRequest.m
//  TeacherPro
//
//  Created by DCQ on 2017/4/27.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "NetRequest.h"
#import "PublicDocuments.h"
#import "NetRequestManager.h"
#import "CachedDownloadManager.h"

NSString * const cacheKey = @"CacheKey";
NSString * const cacheExpiresInSecondsKey = @"CacheExpiresInSecondsKey";
static NSString * const CODEKEY = @"resultCode";
static NSString * const MESSAGEKEY    =      @"message";
static NSString * const SUCCESSKEY    =     @"success";

@implementation NetRequest
@synthesize delegate;
@synthesize tag;
@synthesize userInfo;
@synthesize manager;
@synthesize resultInfoObj;
@synthesize resultErorr;
@synthesize didUseCachedResponse;
- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)dealloc
{
    if (manager) manager = nil;
    if (userInfo)userInfo =nil ;
    if (resultInfoObj) resultInfoObj =nil ;
    if (resultErorr) resultErorr =nil;
    if (self.delegate) self.delegate = nil;
    
}

- (void)starRequest{
    
    
    if ([self.methodType isEqualToString:RequestMethodType_UPLOADIMG] && self.delegate &&[self.delegate  respondsToSelector:@selector(netRequestDidStarted:)]){
        
        [delegate netRequestDidStarted:self];
        
    }else if([self.methodType isEqualToString:RequestMethodType_UPLOADAUDIO] && self.delegate &&[self.delegate  respondsToSelector:@selector(netRequestDidStarted:)]){
       [delegate netRequestDidStarted:self];
    } else if ([self.methodType isEqualToString:RequestMethodType_DOWNLOAD] && self.delegate &&[self.delegate  respondsToSelector:@selector(netRequestDidStartedDownload:)]){
        
        [delegate netRequestDidStartedDownload:self];
        
    }else{
        if ( self.delegate && [self.delegate respondsToSelector:@selector(netRequestDidStarted:)])
        {
            [delegate netRequestDidStarted:self];
        }
    }
    
    
    if ([self.methodType isEqualToString:RequestMethodType_GET]) {
        
        [self sendGetRequest];
        
    }else if ([self.methodType isEqualToString:RequestMethodType_POST]){
        
        [self sendNormalPost];
        
    }else if ([self.methodType isEqualToString:RequestMethodType_UPLOADIMG]){
        [self sendPostUploadImgFile];
    }else if ([self.methodType isEqualToString:RequestMethodType_UPLOADAUDIO]){
        [self sendPostUploadAudioFile];
    } else if ([self.methodType isEqualToString:RequestMethodType_DOWNLOAD]){
        
        /*
        [self sendDownloadFile];
         */
    }
    
    
    
}
//发起get 类型网络请求
- (void)sendGetRequest{
    
    self.task =  [self.manager  GET:self.url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}



//默认Post 请求
- (void)sendNormalPost{
    NSString * urlStr = self.url.absoluteString;
    
    

  
    self.task  = [self.manager POST:urlStr parameters:self.parameterDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        [self isValidationData:responseDict];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        self.resultErorr =error;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(netRequest:failedWithError:)])
        {
            [delegate netRequest:self failedWithError:error];
        }
        [[NetRequestManager sharedInstance] removeRequest:self];
        
         
    }];
    
}


//Post上传文件 请求
- (void)sendPostUploadImgFile{
    
    
    [self.manager POST:self.url.absoluteString parameters:self.parameterDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSString *key in self.fileDic.allKeys)
        {
            
            // 上传文件路径
//            NSString *filePath = [self.fileDic objectForKey:key];
//            NSString *fileName = [filePath substringFromIndex:[filePath rangeOfString:@"/" options:NSBackwardsSearch].location + 1];
////            //把要上传的图片转成NSData
//            NSData*fileData = [NSData dataWithContentsOfFile:filePath];
            NSData * fileData;
            NSString * fileName = key;
            NSString * mimeType ;
            if ([[self.fileDic objectForKey:key] isKindOfClass:[UIImage class]]) {
          
                UIImage * image = [self.fileDic objectForKey:key];
                fileData =UIImageJPEGRepresentation(image,0.5);
                mimeType = @"image/png";
                /*常用数据流类型：
                 
                 @"image/png" 图片
                 
                 @“video/quicktime” 视频流
                 
                 */
                [formData appendPartWithFileData:fileData name:fileName fileName:[NSString stringWithFormat:@"%@.jpg",fileName] mimeType:mimeType];//给定数据流的数据名，文件名，文件类型（以图片为例）
            }else{
               [self.fileDic objectForKey:key];
                [formData appendPartWithFileURL:[self.fileDic objectForKey:key] name:@"file" error:nil];
             
                
            }
            
    
        }
        
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"进度表示形式1：%f", uploadProgress.fractionCompleted);
        NSLog(@"进度表示形式2：%@", uploadProgress.localizedDescription);
        NSLog(@"进度表示形式3：%@", uploadProgress.localizedAdditionalDescription);
//        // @property int64_t totalUnitCount;  需要下载文件的总大小
//        // @property int64_t completedUnitCount; 当前已经下载的大小
//        
//        // 给Progress添加监听 KVO
//        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
//        CGFloat progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
//
//        CGFloat progress = uploadProgress.fractionCompleted;
//        if (self.delegate && [self.delegate respondsToSelector:@selector(netRequest:setProgress:)]) {
//            [self.delegate netRequest:self setProgress:progress];
//        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功==%@",responseObject); //返回结果
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        [self isValidationData:responseDict];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败%@",error.localizedDescription);//请求失败结果
        NSLog(@"%@", error);
        self.resultErorr =error;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(netRequest:failedWithError:)])
        {
            [delegate netRequest:self failedWithError:error];
        }
        [[NetRequestManager sharedInstance] removeRequest:self];
    }];
    
    
    
}

- (void)sendPostUploadAudioFile{
    
    
    [self.manager POST:self.url.absoluteString parameters:self.parameterDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSString *key in self.fileDic.allKeys)
        {
            
            // 上传文件路径
            //            NSString *filePath = [self.fileDic objectForKey:key];
            //            NSString *fileName = [filePath substringFromIndex:[filePath rangeOfString:@"/" options:NSBackwardsSearch].location + 1];
            ////            //把要上传的图片转成NSData
            //            NSData*fileData = [NSData dataWithContentsOfFile:filePath];
       
            NSString * fileName = key;
       
           
            NSURL * url = [self.fileDic objectForKey:key];
 
            
            NSData * Sounddata=[NSData dataWithContentsOfFile:url.absoluteString];//同样转化二进制数据上传
            
            [formData appendPartWithFileData:Sounddata name:fileName fileName:fileName mimeType:@"amr/mp3/wmr"];
            
        }
        
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"进度表示形式1：%f", uploadProgress.fractionCompleted);
        NSLog(@"进度表示形式2：%@", uploadProgress.localizedDescription);
        NSLog(@"进度表示形式3：%@", uploadProgress.localizedAdditionalDescription);
        //        // @property int64_t totalUnitCount;  需要下载文件的总大小
        //        // @property int64_t completedUnitCount; 当前已经下载的大小
        //
        //        // 给Progress添加监听 KVO
        //        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        //        CGFloat progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        //
        //        CGFloat progress = uploadProgress.fractionCompleted;
        //        if (self.delegate && [self.delegate respondsToSelector:@selector(netRequest:setProgress:)]) {
        //            [self.delegate netRequest:self setProgress:progress];
        //        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功==%@",responseObject); //返回结果
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        [self isValidationData:responseDict];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败%@",error.localizedDescription);//请求失败结果
        NSLog(@"%@", error);
        self.resultErorr =error;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(netRequest:failedWithError:)])
        {
            [delegate netRequest:self failedWithError:error];
        }
        [[NetRequestManager sharedInstance] removeRequest:self];
    }];
    
    
    
}
//下载文件请求
- (void)sendDownloadFile{
//    NSURL *URL = [NSURL URLWithString:@"http://www.baidu.com/img/bdlogo.png"];
    
    NSURL *URL = self.url;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //AFN3.0+基于封住URLSession的句柄
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //下载Task操作
    self.downloadTask = [self. manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // @property int64_t totalUnitCount;  需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        
        // 给Progress添加监听 KVO
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        CGFloat progress = downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        // 回到主队列刷新UI
        if (self.delegate && [self.delegate respondsToSelector:@selector(netRequest:setProgress:)]) {
            [self.delegate netRequest:self setProgress:progress];
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        //使用建议的路径
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
         NSLog(@"下载的文件存放路径===%@",path);
        return [NSURL fileURLWithPath:path];//转化为文件路径
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        
        //下载成功
        if (error == nil) {
             NSLog(@"文件存放路径===%@",[filePath path]);
        }else{//下载失败的时候，只列举判断了两种错误状态码
            NSString * message = nil;
            if (error.code == - 1005) {
                message = @"网络异常";
            }else if (error.code == -1001){
                message = @"请求超时";
            }else{
                message = @"未知错误";
            }
            NSLog(@"下载文件错误====%@",message);
        }
//        NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
//        UIImage *img = [UIImage imageWithContentsOfFile:imgFilePath];
    
        
    }];
     //开始下载
    [self.downloadTask resume];
    
    //暂停下载
//    [self.downloadTask suspend];
  
}
 

//responseObject  必须是NSDictionary
- (void)isValidationData:(id)responseObject{
    
    id result = nil;
    
    
    if ([self isParseSuccessWithResponseData:responseObject result:&result]) {
        
//        if (!result[@"data"]) {
//            
//        }
        [self cacheResponseObject:responseObject];
        // 回调委托
        self.resultInfoObj =  result[@"data"];
        self.didUseCachedResponse = NO;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(netRequest:successWithInfoObj:)])
        {
            [delegate netRequest:self successWithInfoObj:self.resultInfoObj];
        }
        
    }else{
        
        
        self.resultErorr = (NSError *)result;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(netRequest:failedWithError:)])
        {
            [delegate netRequest:self failedWithError:self.resultErorr];
        }
        
        
    }
    [[NetRequestManager sharedInstance] removeRequest:self];
}


- (void)cacheResponseObject:(NSDictionary *)responseObject{

    // 缓存数据
    NSString *cacheKeyStr = [self.userInfo objectForKey:cacheKey]; // 缓存key值
    NSNumber *expiresInSeconds = [self.userInfo objectForKey:cacheExpiresInSecondsKey]; // 缓存时间
    
    if (cacheKeyStr && 0 != cacheKeyStr.length && expiresInSeconds)
    {
        NSData * responseObjectData = [NSJSONSerialization dataWithJSONObject:responseObject[@"data"] options:NSJSONWritingPrettyPrinted error:nil];
        
        [CachedDownloadManager storeResponseData: responseObjectData cacheKey:cacheKeyStr expiresInSeconds:expiresInSeconds.doubleValue];
    }

}
//数据解析
- (BOOL)isParseSuccessWithResponseData:(NSDictionary *)responseObject result:(id *)result
{
    if (!responseObject) {
        NSLog(@"数据格式不是json");
        return NO;
    }
    
    
    //    NSLog(@"result = %@",resultStr);
    
    //    NSLog(@"resultDic = %@",*result);
    
    // 做服务器返回的业务code判断,因为如果服务器方法报错或者业务逻辑出错HTTP码还是返回的200,但是加了自己定义的一套code码(详情可参考WIKI上面的约定)
    
    NSError *err;
    *result = responseObject;
    if (err)
    {
        *result = err;
        
        return NO;
    }
    
    NSNumber *myCodeNum ;
    NSString *myMsgStr;
    NSNumber *mySuccessStr;
    if ([*result objectForKey:CODEKEY] &&![[*result objectForKey:CODEKEY] isKindOfClass:[NSNull class]]) {
        myCodeNum = [*result objectForKey:CODEKEY];
    }
    if ([*result objectForKey:MESSAGEKEY] &&![[*result objectForKey:MESSAGEKEY] isKindOfClass:[NSNull class]]) {
        myMsgStr = [*result objectForKey:MESSAGEKEY];
    }
    if ([*result objectForKey:SUCCESSKEY]&&![[*result objectForKey:SUCCESSKEY] isKindOfClass:[NSNull class]]) {
        mySuccessStr = [*result objectForKey:SUCCESSKEY];
    }
    
    
    if (myCodeNum && MyHTTPCodeType_Success != myCodeNum.integerValue && ![mySuccessStr boolValue])
    {
        err = [[NSError alloc] initWithDomain:@"MYSERVER_ERROR_DOMAIN" code:myCodeNum.integerValue userInfo:[NSDictionary dictionaryWithObjectsAndKeys:myMsgStr, NSLocalizedDescriptionKey, nil]];
        
        *result = err;
        
        // 自动跳入登录页面
        if (MyHTTPCodeType_TokenOverdue == myCodeNum.integerValue || MyHTTPCodeType_TokenIncomplete == myCodeNum.integerValue || MyHTTPCodeType_TokenIllegal == myCodeNum.integerValue||
            MyHTTPCodeType_NoLogin      == myCodeNum.integerValue||
            MyHTTPCodeType_NoUser  == myCodeNum.integerValue||
            MyHTTPCodeType_NoStudent == myCodeNum.integerValue)
        {
            if ([delegate isKindOfClass:[UIViewController class]])
            {
                //                修改成发送登录通知
                //                    [[NSNotificationCenter defaultCenter] postNotificationName:PLEASELOGIN_NotificationKey object:nil];
              
            }
        }
        
        return NO;
    }
    
    
    return YES;
}

@end
