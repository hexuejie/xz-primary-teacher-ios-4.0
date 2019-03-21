//
//  VersionUtils.m
//  AplusKidsMasterPro
//
//  Created by DCQ on 2017/4/1.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "VersionUtils.h"
//#import "CommonConfig.h"
#import "AlertView.h"
#include "AFNetworking.h"
#import "AFNetworking.h"
#import "Interface.h"
#import "AppDelegate.h"

#define APPID 1222231450

#define UPDATEMSG  @"我们进行了一些重要改变，为不影响您正常使用，请更新到最新版本。"

typedef NS_ENUM(NSInteger, VersionUtilsType) {
    VersionUtilsType_normal   =  0,
    VersionUtilsType_chooseUpdate    ,//小版本 小bug 可选择性更新
    VersionUtilsType_mandatoryChooseUpdate,//大bug 必须更新才能使用
    VersionUtilsType_mandatoryUpdate ,//强制更新 不提示用户（????????）
};
@implementation VersionUtils
#pragma mark 版本更新
+ (void)checkVersionIsShowSmallVersionAlert:(BOOL) yesOrNo
{
//    [VersionUtils  startAppStoreUrlIsShowSmallVersionAlert:yesOrNo];
     [VersionUtils  startMySelfServerIsShowSmallVersionAlert:yesOrNo];
}
+ (void)startMySelfServerIsShowSmallVersionAlert:(BOOL) yesOrNo{
    NSURL * url = [self getMyselfServerAPPInfoURL];
    NSMutableDictionary * requestParameterDic = [NSMutableDictionary dictionary ];
    NSMutableDictionary * tempParametersDic = [NSMutableDictionary dictionary ];
     NSString *urlMethodName  = @"QueryLastAppVersion";
    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];  
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    [tempParametersDic addEntriesFromDictionary:@{@"platform":@[@"ios"]}];
    
    [requestParameterDic addEntriesFromDictionary:@{@"id":@(999999999989989)}];
    [requestParameterDic addEntriesFromDictionary:@{@"functionName": urlMethodName}];
    [requestParameterDic addEntriesFromDictionary:@{@"parameters":tempParametersDic}];
    
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
     AFHTTPSessionManager * manager  = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    // 设置请求格式
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
 
    [ manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //
    //    // 设置超时时间
    [ manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
     manager.requestSerializer.timeoutInterval = 20;
    [ manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //    //     设置返回格式
     manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [ manager POST:url.absoluteString parameters: requestParameterDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        if ( responseDict && responseDict[@"data"] && responseDict[@"data"][@"appVersion"]) {
            NSLog(@"\n=%@===responseDict",responseDict);
            
            NSDictionary * appVersion = responseDict[@"data"][@"appVersion"];
            if (appVersion[@"lastVersion"] && [appVersion[@"lastVersion"] isKindOfClass:[NSString class]]) {
                NSString *localVersion = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                NSString *newVersion = appVersion[@"lastVersion"];
                NSString * releaseNote = @"";
                if (appVersion[@"releaseNote"]) {
                    releaseNote = [appVersion[@"releaseNote"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"] ;
                }
                if (appVersion[@"minVersion"] == nil) {
                    [VersionUtils isShowSmallVersionAlert:NO withLocalVersion:localVersion withNewVersion:newVersion withAlertContent:releaseNote];
                }else{
                    [VersionUtils isShowSmallVersionAlert:yesOrNo withLocalVersion:localVersion withNewVersion:newVersion withAlertContent:releaseNote];
                }
            }
        }
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@===error", error);
        
    }];
    
 
}

+ (void)startAppStoreUrlIsShowSmallVersionAlert:(BOOL) yesOrNo{
    NSURL * url = [self getAPPStoreAPPInfoURL];
    
    
    
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //4.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            //6.解析服务器返回的数据
            //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
            //            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            //
            //            NSLog(@"%@",dict);
            
            NSString *jsonResponseString = [[NSString  alloc]initWithData:data   encoding:NSUTF8StringEncoding  ];
            NSLog(@"通过appStore获取的数据信息：%@",jsonResponseString);
            
            
            if (jsonResponseString != nil && [jsonResponseString  length] > 0 && [jsonResponseString rangeOfString:@"version"].length == 7) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [VersionUtils checkAppUpdate: jsonResponseString  isShowSmallVersionAlert:yesOrNo];
                });
                
            }
        }
    }];
    
    //5.执行任务
    [dataTask resume];
}
+ (void)checkAppUpdate:(NSString *)jsonResponseString isShowSmallVersionAlert:(BOOL) yesOrNo{
    
    
    /*
     版本升级 第一位：大版本    第二位 ：大bug   第三位：小bug
     大版本 大bug 必须强制更新才能使用
     
     */
    
    /*
     
     */
    
    //获取本地软件的版本号
    NSString *localVersion = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSString *newVersion;
    
    NSData *data = [jsonResponseString dataUsingEncoding:NSUTF8StringEncoding];
    
    //    解析json数据
    
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *array = json[@"results"];
    
    for (NSDictionary *dic in array) {
        
        newVersion = [dic valueForKey:@"version"];
        
    }
    
    NSString * alertContent = [VersionUtils getAppStoreAlertContentNewVersion:newVersion withLocalVersion:localVersion];
    
    [VersionUtils isShowSmallVersionAlert:yesOrNo withLocalVersion:localVersion withNewVersion:newVersion withAlertContent:alertContent];
    
}
+ (NSString *)getAppStoreAlertContentNewVersion:(NSString*)newVersion withLocalVersion:(NSString *)localVersion{
    
    NSLog(@"通过appStore获取的版本号是：%@",newVersion);
    NSString *alertContent = [NSString stringWithFormat:@"当前版本是 %@，\n发现最新版本 %@，\n是否立即更新？",localVersion,newVersion];
    NSArray * newVersionArray = [newVersion componentsSeparatedByString:@"."];
    NSArray * localVersionArray = [localVersion componentsSeparatedByString:@"."];
    
    if ( !localVersionArray || !newVersionArray || [newVersionArray count]<= 1 ) {
        //  小于等于一个版本号 暂不处理
        return @"";
    }else if ([newVersionArray count]== 2) {
        //强制用户更新
        
    }else{
        
        //大版本更新
        if ([newVersionArray[0] intValue] > [localVersionArray[0] intValue]) {
            alertContent = [NSString stringWithFormat:UPDATEMSG];
            
            
        }else{
            //大bug更新
            if ([newVersionArray[0] intValue] ==[localVersionArray[0] intValue] &&[newVersionArray[1] intValue] > [localVersionArray[1] intValue]) {
                alertContent = [NSString stringWithFormat:UPDATEMSG];
                
                
            }else  if ([newVersionArray[0] intValue] ==[localVersionArray[0] intValue] &&[newVersionArray[1] intValue] == [localVersionArray[1] intValue]&&[newVersionArray[2] intValue] > [localVersionArray[2] intValue]) {
                
                //小bug 提醒用户有新版本更新 不强制
                
            }
            
            
        }
        
    }
    return alertContent;
}
+(void)isShowSmallVersionAlert:(BOOL) yesOrNo withLocalVersion:(NSString *)localVersion withNewVersion:(NSString *)newVersion  withAlertContent:(NSString *)alertContent {
 
    NSString *msg = alertContent;
    NSString * title = @"版本更新";
    NSArray * newVersionArray = [newVersion componentsSeparatedByString:@"."];
    NSArray * localVersionArray = [localVersion componentsSeparatedByString:@"."];
    
    if ( !localVersionArray || !newVersionArray || [newVersionArray count]<= 1 ) {
        //  小于等于一个版本号 暂不处理
        return ;
    }else if ([newVersionArray count]== 2) {
        //强制用户更新
        
    }else{
        
        //大版本更新
        if ([newVersionArray[0] intValue] > [localVersionArray[0] intValue]) {
//            msg = [NSString stringWithFormat:UPDATEMSG];
            
            [VersionUtils showAlerView:title content:msg leftBtnTitle:@"退出" rightBtnTitle:@"更新" type:VersionUtilsType_mandatoryChooseUpdate];
            
            
        }else{
            //大bug更新
            if ([newVersionArray[0] intValue] ==[localVersionArray[0] intValue] &&[newVersionArray[1] intValue] > [localVersionArray[1] intValue]) {
//                msg = [NSString stringWithFormat:UPDATEMSG];
                
                [VersionUtils showAlerView:title content:msg leftBtnTitle:@"退出" rightBtnTitle:@"更新" type:VersionUtilsType_mandatoryChooseUpdate];
                
                
            }else  if ([newVersionArray[0] intValue] ==[localVersionArray[0] intValue] &&[newVersionArray[1] intValue] == [localVersionArray[1] intValue]&&[newVersionArray[2] intValue] > [localVersionArray[2] intValue]) {
                
                //小bug 提醒用户有新版本更新 不强制
                [VersionUtils showAlerView:title content:msg leftBtnTitle:@"下次再说" rightBtnTitle:@"更新" type:VersionUtilsType_chooseUpdate];
                
                
            }
            
            
        }
        
    }
    
}


+ (void)showAlerView:(NSString *)title content:(NSString *)msg leftBtnTitle:(NSString *)leftTitle rightBtnTitle:(NSString *)rightTitle type:(VersionUtilsType )type{

    MMPopupItemHandler leftItemHandler;
    MMPopupItemHandler rightItemHandler;
    
    if (type == VersionUtilsType_chooseUpdate) {
        leftItemHandler = nil;
        rightItemHandler = ^(NSInteger index){
             [self gotoAppStoreInfo];
        };

    }else if (type == VersionUtilsType_mandatoryChooseUpdate){
      
       leftItemHandler = ^(NSInteger index){
            [VersionUtils exitApplication];
        };
        rightItemHandler = ^(NSInteger index){
            [self gotoAppStoreInfo];
            
        };
    }
   
    NSArray *items =
    @[
      MMItemMake(leftTitle, MMItemTypeHighlight, leftItemHandler),
      MMItemMake(rightTitle, MMItemTypeHighlight, rightItemHandler)
      ];
   
    BOOL hasAlert = NO;
    for ( UIView *v in [[MMPopupWindow sharedWindow] attachView].mm_dimBackgroundView.subviews )
    {
        if ( [v isKindOfClass:[MMPopupView class]] )
        {
            hasAlert = YES;
        }
    }
    
    if (!hasAlert) {
        AlertView *alertV =[[AlertView alloc]initWithTitle:title detail:msg items:items];
        alertV.isStrongUpate = YES;
        [alertV show];
    } 
}
//+ (void)exitApplication {
//
//
//    UIWindow *window = [UIApplication sharedApplication].delegate.window;
//    [UIView animateWithDuration:1.0f animations:^{
//
//        window.alpha = 0;
//
//        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
//
//    } completion:^(BOOL finished) {
//
//        exit(0);
//
//    }];
////    [UIView animateWithDuration:1.0f animations:^{
////        window.alpha = 0;
////        window.transform = CGAffineTransformScale(window.transform, 0.1, 0.1);
////        window.frame = CGRectMake(0, 0, 0, 0);
////    } completion:^(BOOL finished) {
////        exit(0);
////    }];
//    //exit(0);
//
//}


+ (void)exitApplication {
    
     AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate ;
    [appDelegate exitApplication];
    
}






+ (NSURL *)getMyselfServerAPPInfoURL{
//    if ([Request_NameSpace_company_internal hasPrefix:@"http://192.168.1.181"]) {//内测
//        UILabel *testtestLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 100, 30)];
//        testtestLabel.text = @"内测";
//        [[UIApplication sharedApplication].keyWindow addSubview: testtestLabel];
//    }else if ([Request_NameSpace_company_internal hasPrefix:@"ttp://218.76.7.150"]) {//内测
//        UILabel *testtestLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 100, 30)];
//        testtestLabel.text = @"外测";
//        [[UIApplication sharedApplication].keyWindow addSubview: testtestLabel];
//    }
    
//    [[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex]
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:Request_NameSpace_company_internal]];//
    if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 2) {//181
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.181/TeacherServer/single_api"]];//
    }else if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 1) {//150
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://218.76.7.150:8080/ajiau-api/TeacherServer/single_api"]];//
    }else if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 0) {//正式
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.p.ajia.cn/TeacherServer/single_api"]];//
    }
    
    return url;
}
+ (NSURL *)getAPPStoreAPPInfoURL{
   NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%d",APPID]];//这个URL地址是该app在iTunes connect里面的相关配置信息。其中id是该app在app store唯一的ID编号。
    return url;
}
//更新页
+ (void)gotoAppStoreInfo{
    NSString *_idStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%d?mt=8",APPID];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_idStr]];
    
}
//评论
+ (void)gotoAppStoreComment{

    [VersionUtils jumpToScorePage];
}



+ (void)jumpToScorePage
{
    if ( @available(iOS 11 , * )) {
       
        NSString *itunesurl =[NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%d?mt=8&action=write-review",APPID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl]];
    }else{
        //     这里写的URL地址是该app在app store里面的下载链接地址，其中ID是该app在app store对应的唯一的ID编号。
            NSString *_idStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%d?mt=8",APPID];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_idStr]];
//        NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d&pageNumber=0&sortOrdering=2&mt=8", APPID];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
    
}


@end
