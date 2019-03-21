//
//  AppDelegate.m
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "AppDelegate.h"
#import "AppPropertiesInitialize.h"
#import "VersionUtils.h"
#import "LoginController.h"
#import "PublicDocuments.h"
#import "Interface.h"
#import "SessionHelper.h"
#import "LoginController.h"
#import "UserInfoViewController.h"
#import "TabbarConfigManager.h"
#import <CoreLocation/CoreLocation.h>

#if TARGET_IPHONE_SIMULATOR
#else
#import "WXApi.h"
#import "WXApiObject.h"
#endif
#import <TencentOpenAPI/TencentOAuth.h>


#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "SessionModel.h"
#import "ProUtils.h"
#import <AVFoundation/AVFoundation.h>
#import <UMMobClick/MobClick.h>
#import "TNTabbarController.h"
#import "ClassManagementNewViewController.h"
#import "AddressListViewController.h"
#import "HBDNavigationController.h"
#import "UIViewController+HBD.h"

//#import "ESHttpClient.h"
#import <Bugly/Bugly.h>

@interface AppDelegate ()
#if TARGET_IPHONE_SIMULATOR
#else
<WXApiDelegate,JPUSHRegisterDelegate>
#endif
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
     /////进行应用程序一系列属性的初始化设置
    [AppPropertiesInitialize startAppPropertiesInitialize];
   
    /**
     检测用户是否对本应用打开定位权限。
     */
    [CLLocationManager authorizationStatus];
   
    if (IOS8) { //iOS8以上包含iOS8
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
            NSLog(@"没有打开---通知，暂时无法接受通知");
        }
    }else{ // ios7 一下
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes]  == UIRemoteNotificationTypeNone) {
             NSLog(@"没有打开---通知，暂时无法接受通知");
        }
    }
    [self regitsterThreeKey:launchOptions];
    [self customizeNavigationInterface];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setupRootViewController];
    [self.window makeKeyAndVisible];
    
    [self requestAddBookcase];
    return YES;
}

- (void)requestAddBookcase{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:RequestBaseIndex forKey:EnvironmentIndex];//////0.生产环境 1.150环境 2.181181181测试环境
    
}
////【链接】{"runningEnvironmentIndex":1}...
////http://znxunzhi-primary.oss-cn-shenzhen.aliyuncs.com/config/app_teacher_environment.json
////赵老师  14:57:59
//////0.生产环境 1.150环境 2.181测试环境

- (void)regitsterThreeKey:(NSDictionary *)launchOptions{
    
    [self registerShareKey];
    [self registerJPushKey:launchOptions];
    [self umengTrack];
    [self regitsterBuglyKey];
}
- (void)regitsterBuglyKey{
    
    [Bugly startWithAppId: BuglyAppKey];
}
-  (void)setupRootViewController{
    
    if ([[SessionHelper sharedInstance]checkUserStatus]) {
//
        /**
         重新设置导航条样式
         */
//        [[UINavigationBar appearance] setBackgroundImage:[ProUtils createImageWithColor:[UIColor whiteColor] withFrame: CGRectMake(1, 1, 1, 1)] forBarMetrics:UIBarMetricsDefault ];
//        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        NSString * sex = [[SessionHelper sharedInstance] getAppSession].sex ;
        if (!sex) {
            
            UserInfoViewController * userInfo = [[UserInfoViewController alloc]initWithNibName:NSStringFromClass([UserInfoViewController class ]) bundle:nil];;
            HBDNavigationController * userInfoVC =  [[HBDNavigationController alloc]initWithRootViewController:userInfo];
            
             self.window.rootViewController = userInfoVC;
        }else{
           self.window.rootViewController = [TabbarConfigManager getTabbarViewController:TabbarViewControllerType_Login withDelegate:self];
        }
        
    }else {
  
        LoginController * loginVC = [[LoginController alloc]initWithNibName:NSStringFromClass([LoginController class]) bundle:nil];
 
        HBDNavigationController * loginNaviVC =  [[HBDNavigationController alloc]initWithRootViewController:loginVC];
        self.window.rootViewController = loginNaviVC;
    }
    

 
}
- (void)umengTrack {
    //    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleShortVersionString里取
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = UMengAppKey;
//    UMConfigInstance.secret = @"secretstringaldfkals";
    //    UMConfigInstance.eSType = E_UM_GAME;
    [MobClick startWithConfigure:UMConfigInstance];
}
//注册 第三方需要的key值
- (void)registerShareKey{
    
    
#if TARGET_IPHONE_SIMULATOR
#else
    //微信注册
    //向微信注册
    [WXApi registerApp:kWXAppKey enableMTA:YES];
    
    //向微信注册支持的文件类型
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
    
    [WXApi registerAppSupportContentFlag:typeFlag];
#endif
}


- (void)registerJPushKey:(NSDictionary *)launchOptions{

    // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //      NSSet<UNNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
        //    else {
        //      NSSet<UIUserNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    BOOL oroduction = is_production;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 2) {//181
        oroduction = FALSE;//
    }else if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 1) {//150
        oroduction = FALSE;//
    }else if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 0) {//正式
        oroduction = YES;//
    }
    
    NSString * channel = @"iOS小佳老师APP";
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey
                          channel:channel
                 apsForProduction:oroduction
            advertisingIdentifier:nil];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"clientId"];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    

}
/// 自定义导航条
- (void)customizeNavigationInterface {
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor_gray,NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium]}];
    
//    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
//        [[UINavigationBar appearance] setTranslucent:NO];
//    }
//    [[UINavigationBar appearance]setBarTintColor:project_main_blue];
    [[UINavigationBar appearance] setTintColor:project_main_blue];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UINavigationBar appearance]setShadowImage:[self createImageWithColor:tn_border_color withFrame:CGRectMake(0, 0, IPHONE_WIDTH, 0.1f)]];
    [[UIApplication sharedApplication]  setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    //按钮文字
//    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    
    
  
    
    UIImage *barBackBtnImg = [[UIImage imageNamed:@"testreturn"] imageWithRenderingMode:UIImageRenderingModeAutomatic]   ;
    
    [[UINavigationBar appearance] setBackIndicatorImage:barBackBtnImg];
    
    [[UINavigationBar appearance]setBackIndicatorTransitionMaskImage:barBackBtnImg];
//    [UIBarButtonItem appearance].imageInsets = UIEdgeInsetsMake(0, -13, 0, 0);
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:barBackBtnImg
//                                                      forState:UIControlStateNormal
//                                                    barMetrics:UIBarMetricsDefault];
    
}

- (UIImage*) createImageWithColor: (UIColor*) color withFrame:(CGRect)rect
{
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
      [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

//// app启动或者app从后台进入前台都会调用这个方法
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [VersionUtils checkVersionIsShowSmallVersionAlert:NO];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@",[self logDic:userInfo]);
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@",  [self logDic:userInfo]);
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
        
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
       
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
     
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


- (void)exitApplication {
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    //来 加个动画，给用户一个友好的退出界面
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    
    // [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:window cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
   
    window.bounds = CGRectMake(0, 0, 0, 0);
    
   
    if ([window.rootViewController isKindOfClass: [TNTabbarController class]]) {
       TNTabbarController *tabbarController   = (TNTabbarController *)window.rootViewController;
        tabbarController.tabBar.bounds = CGRectMake(0, 0, 0, 0);
        tabbarController.contentView.bounds = CGRectMake(0, 0, 0, 0);
     
        tabbarController.selectedViewController.view.alpha = 0;
        tabbarController.contentView.alpha = 0;
        tabbarController.view.alpha = 0;
        tabbarController.tabBar.alpha = 0;
     
    }
 
    [UIView commitAnimations];
    
    
    
}




- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    
    
    if ([animationID compare:@"exitApplication"] == 0) {
    
        exit(0);
    }
    
    
    
}

#pragma mark --- 是否绑定学校

- (BOOL)tabBarController :(TNTabbarController *)tabBarController shouldSelectViewController:(UIViewController *) viewController{
    UINavigationController *nav = (UINavigationController *)viewController;
    UIViewController *VC =nav.topViewController;
     SessionModel *sesstion = [[SessionHelper sharedInstance] getAppSession];
      if ([VC isKindOfClass:[ClassManagementNewViewController class]] && !sesstion.schoolId) {
          [self showBindingAlert];
        return NO;
     }
    return YES;
}
- (void)showBindingAlert{
    
    NSString * title = @"温馨提示";
    NSString * content = @"您需要绑定学校才可使用其它功能！";
    
    MMPopupItemHandler sureHandler = ^(NSInteger index){
        [self gotoAddressVC];
    };
    
    MMPopupItemHandler cancelHandler = ^(NSInteger index){
        
    };
    NSArray * items = @[MMItemMake(@"暂不绑定", MMItemTypeHighlight, cancelHandler),
                        MMItemMake(@"去绑定", MMItemTypeHighlight, sureHandler)];
    [self showNormalAlertTitle:title content:content  items:items block:sureHandler];
    
}
- (void)showNormalAlertTitle:(NSString* )title content:(NSString *)content items:(NSArray *)items block:(MMPopupItemHandler) itemHandler{
    
    if (!items) {
        items =
        @[MMItemMake(@"取消", MMItemTypeHighlight, nil),
          MMItemMake(@"确定", MMItemTypeHighlight, itemHandler)];
    }
    AlertView * alert = [[AlertView  alloc]initWithTitle:title detail:content items:items ];
    [alert show];
    
    
}
- (void)gotoAddressVC{
    
    AddressListViewController * addressVC = [[AddressListViewController alloc]init];
    addressVC.hbd_barAlpha = 1;
    addressVC.hbd_tintColor = [UIColor whiteColor];
    addressVC.hbd_barTintColor =  project_main_blue;
    addressVC.addressSuccessblock = ^{
        TNTabbarController * tabbarVC = (TNTabbarController *)self.window.rootViewController;
         tabbarVC.selectedIndex =  1;
    };
    HBDNavigationController * nv = [[HBDNavigationController alloc]initWithRootViewController:addressVC];

   TNTabbarController * tabbarVC = (TNTabbarController *)self.window.rootViewController;
   [tabbarVC.viewcontrollerArray[0] presentViewController:nv animated:YES completion:nil];
    
 
    
}
@end
