//
//  ShareManagerUtils.m
//  AplusKidsMasterPro
//
//  Created by DCQ on 2017/4/13.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "ShareManagerUtils.h"
#import <MessageUI/MessageUI.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import "TencentOpenAPI/QQApiInterface.h"
#import "PublicDocuments.h"
#if TARGET_IPHONE_SIMULATOR
#else
#import "WXApi.h"
#endif



UIAlertView *SimpleAlert(UIAlertViewStyle style, NSString *title, NSString *message, NSInteger tag, id delegate, NSString *cancel, NSString *ok)
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancel otherButtonTitles:ok, nil];
    alert.alertViewStyle = style;
    alert.tag = tag;
    [alert show];
    return alert ;
}

@interface ShareManagerUtils()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,TencentSessionDelegate
#if TARGET_IPHONE_SIMULATOR
#else
,WXApiDelegate
#endif
>
@property (nonatomic,strong) TencentOAuth        *tencentOAuth;
@property (nonatomic,strong) NSMutableArray      *permissions;
@property (nonatomic,strong) NSDictionary *shareContentDic;
@property (nonatomic,strong) UIViewController *rootViewController;
@end
@implementation ShareManagerUtils
+ (ShareManagerUtils *)shareManager
{
    static ShareManagerUtils *staticShareManager = nil;
    static dispatch_once_t paredicate;
    dispatch_once(&paredicate, ^{
        staticShareManager = [[ShareManagerUtils alloc] init];
    });
    
    return staticShareManager;
}

- (id)init
{
    //注意： 初始化授权 开发者需要在这里填入自己申请到的 AppID
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQAppKey andDelegate:self];
    
    return self;
}
#pragma mark - MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

//- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
//{
//    [controller dismissViewControllerAnimated:YES completion:nil];
//}

- (void)setup{
    NSString *appid = kQQAppKey;
    
    _permissions = [NSMutableArray arrayWithObjects:
                    kOPEN_PERMISSION_GET_USER_INFO,
                    kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                    kOPEN_PERMISSION_ADD_ALBUM,
                    kOPEN_PERMISSION_ADD_ONE_BLOG,
                    kOPEN_PERMISSION_ADD_SHARE,
                    kOPEN_PERMISSION_ADD_TOPIC,
                    kOPEN_PERMISSION_CHECK_PAGE_FANS,
                    kOPEN_PERMISSION_GET_INFO,
                    kOPEN_PERMISSION_GET_OTHER_INFO,
                    kOPEN_PERMISSION_LIST_ALBUM,
                    kOPEN_PERMISSION_UPLOAD_PIC,
                    kOPEN_PERMISSION_GET_VIP_INFO,
                    kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                    nil] ;
    
    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:appid
                                            andDelegate:self];
     
  
    [self onClickTencentOAuth];
}

/**
 * tencentOAuth
 */
- (void)onClickTencentOAuth {
    [_tencentOAuth setAuthShareType:AuthShareType_QQ];
    [_tencentOAuth authorize:_permissions inSafari:NO];
}


- (void)shareInformationWithContentDic:(NSDictionary *)contentDic rootViewController:(UIViewController *)viewController shareType:(ShareManagerType)type  shareContentType:(ShareContentType )contentType{
    ShareContentType _contentType = contentType;
    
    self.shareContentDic = contentDic;
    self.rootViewController = viewController;
    
    if (type == ShareManagerType_QQFriend||type == ShareManagerType_QQZone) {
        if (![TencentOAuth iphoneQQInstalled]) {
            SimpleAlert(UIAlertViewStyleDefault, nil, @"未安装QQ，不能分享", 1, self, @"确定", nil);
            return ;
        }
    }
    
    if (type == ShareManagerType_WXTimeline||type == ShareManagerType_WXFriend) {
        
#if TARGET_IPHONE_SIMULATOR
#else
        if (![WXApi isWXAppInstalled]) {
            SimpleAlert(UIAlertViewStyleDefault, nil, @"未安装微信，不能分享", 1, self, @"确定", nil);
            return ;
        }
#endif
    }
    
    
    
    
    switch (type) {
        case ShareManagerType_WXFriend:
        {
#if TARGET_IPHONE_SIMULATOR
#else
            if (_contentType == ShareContentType_Text) {
                [self sendWXTextContent:ShareManagerType_WXFriend];
            }
            else if (_contentType == ShareContentType_Line){
                [self sendWxLinkContent:ShareManagerType_WXFriend];
            }
#endif
        }
            break;
            
        case ShareManagerType_QQFriend:
        {
//            [self setup];
            if (_contentType ==  ShareContentType_Text) {
                [self sendQQTextMsg:ShareManagerType_QQFriend];
            }
            else if (_contentType == ShareContentType_Line){
                [self sendQQLinkContent:ShareManagerType_QQFriend];
            }
        }
            break;
        case ShareManagerType_Message:{
            
            [self sendSMSMesssageText:_contentType];
        }
            break;
        case ShareManagerType_WXTimeline:
        {
#if TARGET_IPHONE_SIMULATOR
#else
            //分享朋友圈链接
            [self sendWxLinkContent:ShareManagerType_WXTimeline];
#endif
        }
            break;
            
        case ShareManagerType_QQZone:
        {
//            [self setup];
            
            [self sendQQLinkContent:ShareManagerType_QQZone];
        }
            break;
        default:
            break;
    }
    
}
/**
 * qq Share.
 */

//分享文本
- (void)sendQQTextMsg:(ShareManagerType )type
{
    
    NSString *contentStr =[self.shareContentDic objectForKey:informationContentkey];
    QQApiTextObject* txt = [QQApiTextObject objectWithText:contentStr];
    txt.shareDestType = ShareDestTypeQQ;
    //QQ好友
    if (type == ShareManagerType_QQFriend) {
        txt.cflag = kQQAPICtrlFlagQQShare;
    }
    //qq空间
    else if (type == ShareManagerType_QQZone)
    {
        txt.cflag = kQQAPICtrlFlagQZoneShareOnStart;
    }
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:txt];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}
//分享图片
- (void)sendImageMsg
{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"img.jpg"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    
    QQApiImageObject* img = [QQApiImageObject objectWithData:data previewImageData:data title:@"test title" description:@"desc"];
     img.shareDestType =  ShareDestTypeQQ;
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];

}
//分享新闻链接
- (void)sendQQLinkContent:(ShareManagerType )type{
    
    
    NSString *titleStr      = [self.shareContentDic objectForKey:informationTitlekey];
    NSString *subtitleStr   = [self.shareContentDic objectForKey:informationSubtitlekey];
    NSString *appDownloadUrlStr = [self.shareContentDic objectForKey:informationAppDownloadUrlkey];
    NSString *appIconName = [self.shareContentDic objectForKey:informationAppIconNameKey];
    UIImage  *appIconImg  =  [self.shareContentDic objectForKey:informationShoppingIconImgKey];
    NSString * contentImgUrl = [self.shareContentDic objectForKey:informationContentImgIconKey];
     NSData * imageDate = nil;
    QQApiNewsObject * Obj;
    if (contentImgUrl) {
 
        
        Obj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:appDownloadUrlStr] title:titleStr description:subtitleStr previewImageURL:[NSURL URLWithString:contentImgUrl]];
        
    }else{
       
        if (appIconImg) {
            imageDate = UIImagePNGRepresentation(appIconImg);
        }else{
            imageDate = UIImagePNGRepresentation([UIImage imageNamed:appIconName]);
        }
        
        Obj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:appDownloadUrlStr] title:titleStr description:subtitleStr previewImageData: imageDate];
    }
 
    
    Obj.shareDestType =  ShareDestTypeQQ;
    //QQ好友
    if (type == ShareManagerType_QQFriend) {
        Obj.cflag = kQQAPICtrlFlagQQShare;
    }
    //qq空间
    else if (type == ShareManagerType_QQZone)
    {
        Obj.cflag = kQQAPICtrlFlagQZoneShareOnStart;
    }
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:Obj];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
   
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            //APP未注册
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"分享失败,请稍后再试" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
         
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"分享失败,请稍后再试" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
   
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未安装手Q,请安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
     
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"分享失败,请稍后再试" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
        
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"发送失败,请稍后再试" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
         
            
            break;
        }
        default:
        {
            break;
        }
    }
}


- (void)showInvalidTokenOrOpenIDMessage{
    //api 调用失败
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"可能授权已过期，请重新获取" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
/**
 *  发送短信
 *
 *
 */

- (void)sendSMSMesssageText:(ShareContentType )type
{
    
    
    NSString *titleStr = [self.shareContentDic objectForKey:informationTitlekey];
    NSString *subtitleStr = [self.shareContentDic objectForKey:informationSubtitlekey];
    NSString *appDownloadUrlStr = [self.shareContentDic objectForKey:informationAppDownloadUrlkey];
    NSString *contentStr = [self.shareContentDic objectForKey:informationContentkey];
    
    NSString * message = @"";
    
    if (type == ShareContentType_Line) {
        message = [NSString stringWithFormat:@"%@\n%@\n%@",titleStr,subtitleStr,appDownloadUrlStr];
    }
    else if (type == ShareContentType_Text){
        
        message = [NSString stringWithFormat:@"%@",contentStr];;
    }
    // 判断用户设备能否发送短信
    if (![MFMessageComposeViewController canSendText]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"设备不支持发送短信" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    // 1. 实例化一个控制器
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    // 2. 设置短信内容
    // 1) 收件人
    //    controller.recipients = @[@"10086"];
    
    // 2) 短信内容
    
    
    controller.body = message;
    
    // 3) 设置代理
    controller.messageComposeDelegate = self;
    
    // 3. 显示短信控制器
    [self.rootViewController presentViewController:controller animated:YES completion:nil];
}

//记得发完短信记得调用代理方法关闭窗口

#pragma mark 短信控制器代理方法
/**
 短信发送结果
 
 MessageComposeResultCancelled,     取消
 MessageComposeResultSent,          发送
 MessageComposeResultFailed         失败
 */
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSLog(@"%zd", result);
    
    // 在面向对象程序开发中，有一个原则，谁申请，谁释放！
    // *** 此方法也可以正常工作，因为系统会将关闭消息发送给self
    [controller dismissViewControllerAnimated:YES completion:nil];
}

//微信分享
#if TARGET_IPHONE_SIMULATOR
#else
//发送文本
- (void) sendWXTextContent:(ShareManagerType )type
{
    NSString *contentStr =[self.shareContentDic objectForKey:informationContentkey];
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = contentStr;
    req.bText = YES;
    if (type == ShareManagerType_WXFriend) {
        req.scene = WXSceneSession;
    }else if (type == ShareManagerType_WXTimeline){
        req.scene = WXSceneTimeline;
    }
    
    
    [WXApi sendReq:req];
}
//发送链接
- (void) sendWxLinkContent:(ShareManagerType )type
{
    NSString *headerStr = [self.shareContentDic objectForKey:informationHeaderkey];
    NSString *titleStr = [self.shareContentDic objectForKey:informationTitlekey];
    NSString *subtitleStr = [self.shareContentDic objectForKey:informationSubtitlekey];
    //    NSString *contentStr = [self.shareContentDic objectForKey:informationContentkey];
    
    NSString *appDownloadUrlStr = [self.shareContentDic objectForKey:informationAppDownloadUrlkey];
    NSString *appIconName = [self.shareContentDic objectForKey:informationAppIconNameKey];
    
    UIImage  *appIconImg  =  [self.shareContentDic objectForKey:informationShoppingIconImgKey];
     NSString * contentImgUrl = [self.shareContentDic objectForKey:informationContentImgIconKey];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = titleStr;
    message.description = subtitleStr;
    UIImage *messageImg=nil;
    
    if (contentImgUrl) {
        //同步下载icon
        NSData * imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:contentImgUrl]];
        if (imgData) {
            [message setThumbImage:[UIImage imageWithData: imgData scale:1 ]];
        }else{
           [message setThumbImage:nil];
        }
      
    }else{
        if (appIconImg) {
            messageImg = appIconImg;
            
        }else{
            messageImg = [UIImage imageNamed:appIconName];
        }
        
        [message setThumbImage:messageImg];
    }
  
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = appDownloadUrlStr;
    
    message.mediaObject = ext;
    message.mediaTagName =headerStr;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    //会话
    if (type == ShareManagerType_WXFriend) {
        
        req.scene = WXSceneSession;
    }
    //朋友圈
    else if(type == ShareManagerType_WXTimeline){
        req.scene = WXSceneTimeline;
    }
    
    [WXApi sendReq:req];
}

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        //        GetMessageFromWXReq *temp = (GetMessageFromWXReq *)req;
        
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        //        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        //        NSString *strMsg = [NSString stringWithFormat:@"openID: %@", temp.openID];
        //
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        alert.tag = 1000;
        //        [alert show];
        
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        //        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        //        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        //        WXAppExtendObject *obj = msg.mediaObject;
        
        //        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        //        NSString *strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n附加消息:%@\n", temp.openID, msg.title, msg.description, obj.extInfo, msg.thumbData.length, msg.messageExt];
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //        LaunchFromWXReq *temp = (LaunchFromWXReq *)req;
        //        WXMediaMessage *msg = temp.message;
        
        //        //从微信启动App
        //        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        //        NSString *strMsg = [NSString stringWithFormat:@"openID: %@, messageExt:%@", temp.openID, msg.messageExt];
        //
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }
}


#endif

- (void)tencentDidLogout{
    
}




 
@end
