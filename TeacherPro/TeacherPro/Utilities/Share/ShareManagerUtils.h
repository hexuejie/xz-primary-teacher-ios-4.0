//
//  ShareManagerUtils.h
//  AplusKidsMasterPro
//
//  Created by DCQ on 2017/4/13.
//  Copyright © 2017年 neon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger , ShareManagerType){
    
    ShareManagerType_Nomal = 0         ,
    ShareManagerType_WXFriend          ,//微信好友分享
    ShareManagerType_Message           ,//短信分享
    ShareManagerType_QQFriend          ,//QQ好友
    ShareManagerType_QQZone            ,//QQ空间
    ShareManagerType_WXTimeline        ,//微信朋友圈分享
};
typedef NS_ENUM(NSInteger, ShareContentType){
    ShareContentType_Normal =0          ,
    ShareContentType_Text               ,//文本
    ShareContentType_Line               ,//链接
    /*
     ShareManagerType_Image              ,//图片
     ShareManagerType_V
     */
};
static NSString * const informationHeaderkey            = @"informationHeaderkey";
static NSString * const informationTitlekey             = @"informationTitlekey";
static NSString * const informationSubtitlekey          = @"informationSubtitlekey";
static NSString * const informationContentkey           = @"informationContentkey";
static NSString * const informationAppDownloadUrlkey    = @"informationAppDownloadUrlkey";
static NSString * const informationShoppingIconImgKey   = @"informationShoppingIconImgKey";
static NSString * const informationAppIconNameKey       = @"informationAppIconKey";
static NSString * const informationContentImgIconKey       = @"informationContentImgIconKey";

@interface ShareManagerUtils : NSObject

+ (ShareManagerUtils *)shareManager;
 
//指定分享三方平台
- (void)shareInformationWithContentDic:(NSDictionary *)contentDic rootViewController:(UIViewController *)viewController shareType:(ShareManagerType)type shareContentType:(ShareContentType )contentType;
 
@end
