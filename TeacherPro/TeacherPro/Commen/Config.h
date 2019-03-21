//
//  Config.h
//  eShop
//
//  Created by Kyle on 14-10-11.
//  Copyright (c) 2014年 yujiahui. All rights reserved.
//

#import "UserDefault.h"


#define kUmengKey @"54388f34fd98c54caf01a319"
#define kAppStoreKey 948493942

#define kQQAPPID @"1103536118" // 16进制  41c69ff6
#define kQQAPPKEY @"ROn2XiQeVyxV2e1C"

#define kWXAPPID @"wxfa0e2cafda810005"
#define kWXAPPSECRET @"8651259787c0941de25645b46c107c35"

#define kWXPaySignKey @"bmzRZAja2c7MpJQzeCl5Zq6IJa0osUjePx7aNphrB0YwbWmj3nIymReQ8FH6e5GC6T2N3jJ6OFsj3OLD09q9RSbXNXUYRbmZwDUkgTYTNJPrIxsvpnWxjiv8hFVTpEWB"
#define kWXPayPartnerID @"1224360501"
#define kWXPayPartnerKey @"b634865b2b2e7b34b9472c37327d9ae1"
#define kWXPayNodifyURL @"yunifang/mobile/wxpaynotify/async"


#define kTelephone @"400-688-0900"

#define kUserLoginStatus @"user.login.status"
#define kUserId @"user.userid"
#define kUserIsUnionLogin @"user.isunionlogin"
#define kUserName @"user.username"
#define kUserIcon @"user.icon"
#define kUserPoints @"user.points"
#define kUserSex @"user.sex"
#define kUserNickName @"user.nick.name"
#define kUserEmail @"user.email"
#define kUserPhone @"user.mobile.phone"
#define kUserMemberLevel @"user.member.level"
#define kUserMemberLevelDesc @"user.member.level.desc"
#define kUserCurrentLevelScore @"user.current.level.score"
#define kUserNextLevelScore @"user.next.level.score"
#define kUserAssociateTaobaoFlag @"user.associate.taobao.flag"
#define kUserAssociateTaobaoMsg @"user.associate.taobao.msg"
#define kUserAccountBindMsg @"user.account.bind.msg"
#define kUserLoginType @"user.login.type"
#define kGTPushId @"mijiang_push_id"

#define kBoolMerchantHomeCheckLocation @"merchantHomeCheckLocation"
#define kIntLocationPermissionTime @"merchantHomeCheckLocation.time"
#define kMerchantHomeCheckCity @"merchantHomeCheckCity"
#define kMerchantHomeReCityDete @"merchantHomeReCityDete"
#define kLocationFormerCityName @"locationFormerCityName"
//引导，指示key
#define kMerchantHomeIsLoginRegist @"isLoginRegist"
#define kMerchantHomeGuideKey @"merchantHomeGuide"
#define kQuestionDetialGuideKey @"questionDetialGuide"
#define kHotDetialGuideKey @"hotDetialGuide"
#define kOwnHomeGuideKey @"ownHomeGuide"
#define KLiveHomeFirstAdKey @"firstAd"
#define kLiveHomePostVideo @"firstPostVideo"
#define kPersonalCenterGuide @"personalCenterGuide"
#define kMerchantGuide @"merchantGuide"
#define kQuaereMyEditGuide @"quaereMyEdit"
#define kHotelGuide @"hotelGuide"
//请贴模板分享
#define kQuaereShareKey @"lx.quaere.key_%@"

//请贴模板购买vip
#define kInvitationVipKey @"lx.invitation.key_%@"
//地图信息保存
#define LXQuaereInstWeddingInfo @"LXQuaereInstWeddingInfo%@"
//请贴是否修改或创建
#define kInvitationCreateKey @"lx.invitation.create"


#define KUserInfoComplete @"user.info.complete"

//Location key
#define kLocationLat @"user.location.lat"
#define kLocationlng @"user.location.lng"

#define kLocationCityName @"user.location.city"
#define kLocationCityId @"user.location.id"
#define kLocationCityZiying @"user.locaiton.zy"

#define kLocationRealCityId @"user.location.real.id"
#define kLocationRealCityName @"user.location.real.id"
#define kLocationUserRealCityName @"user.location.real.name"
#define kBoolLocationChecked @"bool.location.checked"
#define kBoolLocationHasDialog @"bool.location.Dialog"
#define kBoolAllowLocation @"bool.location.allow"
//File name
#define kAllCityFile @"lxallcity.plist"
#define kPersonalCenterFile @"lxpersonalcenter.plist"
#define kAllCityUpdateTimeKye @"allcity.update.timeterval"
#define kOwnCityFile @"lxowncity.plist"  //直营城市
#define kGiftFile @"lxgift.plist"  //直营城市
#define kAllAdsFile @"lxallads.plist" //广告
#define kOwnCityUpdateTimeKye @"owncity.update.timeterval"

//地区切换
#define kReadyShowLocationAlert @"lx.location.alert"


/**
 *  AliPay ,没有同意不能轻易更改
 */
#define ALIPAY_DEFAULT_PARTNER @"2088711026538780"
#define ALIPAY_DEFAULT_SELLER @"ynfappsk@yujiahui.com"
#define ALIPAY_PUBLIC @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC8rPqGGsar+BWI7vAtaaDOqphy41j5186hCU9DcchV4HWiv0HvQ3KXAEqHfZiAHZSyMSRMmDZVnqJwCVWFvKUPqU1RsCPZ9Imk+9ZXVkM3DDdw74v/s6YMNx8cTuxybRCJUfOKbyC79cnHgmQqqkODv+EnprBtNKE4k8g90jNmbwIDAQAB"
#define ALIPAY_PRIVATE @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAK8rf2fxBUJv/sE0qnATs1O90+UtVLn7tQZ4Shuzy/VG+xIPxNVJmqrQ/ifJ5DdZqQBZUn9MEKML//IZ9oMdxINKcWohMcAWkdCh6mfmDcMKv8rwZRwwwRLsoAdOt5Ip54r2wPa6G+MxMySO3ut0uNpRiNbKslI/ss8QoV9ZzO3pAgMBAAECgYBmUPnyNI3l6JTdNW34WQl9+Hs0ee3rVGLAjLJ8y+BuPC+atSs7ieqVq81IYFy1F+HnGkVdpYhyNCgjuZaLr2+AaNbSP5J2F2t7EIp0E97uCxcz66r6L/3l57i9eFxh9guPvLD9yKHEqP5cl1EwQNIsBlduCNVva8Q4nPhVJDiUgQJBAN9bl+QtFxtyCAStbXUC8YC3laiy8NWaNyeQM5zeu7XC8FTsjrTr6F2t2ZyFXWBDOVM3uDNJs0/wYLaeP3TZp20CQQDIxRF8mUzXKUpFyAx7ghyj8dn9LVeHEzzjnqN7vt/agYydAoHZpBgSk9xuHIOG4YHMl382LM45FZhXcBdNxebtAkEA2LOkylx07svTu7YHXF9er+Nt8B6sSpE0sc3WRXxT4iUfx0U7r4yyBTGGz7UUwzB1jaehryDyN7ygGI2wQ05ogQJAdATtxgMQ1IWX1ht0myrlQhhQ0G2TVwtW9HKIJsp2sd6LU3BPeWXKQ3IOv9LabueCCqjBap0ZzwMbteugi+EBQQJBALuA+E/6QpksFiEFD9lmFQFLYD3tMIS6UgNdRgKg1+NIqG7rGNrh3Mdn2uol3CghDozMGquNjORnUCoMUkNZQ/g="
#define ALI_NOTIFYURL @"yunifang/mobile/paynotify/async"
#define kALI_SERVICE @"mobile.securitypay.pay"
#define ALIPAY_APPSCHEME @"ynfeshop" //跟应用 info 定义的 URL type 一致，不可更改





#pragma mark
#pragma mark Notification
const static NSNotificationName kUserChangeNotification = @"lx.user.change.notification";

const static NSNotificationName kAllCityChangedNotification = @"lx.city.all.change.notification"; //全局city变化
const static NSNotificationName kLiveChangedNotification = @"lx.live.change.notification"; //新人说

const static NSNotificationName kLiveCreatingSuccessfulChangedNotification = @"lx.creating.successful.change.notification"; //新人说

const static NSNotificationName kQuestionCreatingSuccessfulChangedNotification = @"lx.creating.question.change.notification"; //问答

const static NSNotificationName kLiveArticleDetailDeleteChangedNotification = @"lx.article.detail.delete.notification"; //我的帖子删除
/**
 *  引导页面显示标志
 *  自定义引导版本号，升级时候会判断是否显示
 *  重新安装时候一定会显示
 *  当需要显示的时候，则修改成跟当前版本号一致的版本号
 *
 *  历史版本： 1.2.0
 */

#define YNF_ESHOP_GUIDE_VERSION @"1.5.0"



/**
 *  聊天缓存版本，当缓存升级时候再变化,修改后以前版本缓存不再可用
 *  修改时候请确认再升级
 */


/**
 * 
 *  1.0.0 只发送文字
 *  1.1.0 发送文字以及图片
 *
 */

static const NSString *YNF_ESHOP_CHAT_CACHE_VERSION = @"1.1.0";
#define YNF_ESHOP_CHAT_CACHE_VERSION_USERID_FORMAT @"ynf_eshop_chat_cache_version%@_useid%@"



@interface Config : NSObject

@end
