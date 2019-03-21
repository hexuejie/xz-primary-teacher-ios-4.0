//
//  AppPropertiesInitialize.m
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "AppPropertiesInitialize.h"
#import "NetworkStatusManager.h"
#import "IQKeyboardManager.h"
#import "CommonConfig.h"

@implementation AppPropertiesInitialize
+ (void)startAppPropertiesInitialize
{
    // 开启网络状态监听
    [NetworkStatusManager startNetworkStatus];
    
    /*
     在执行App之前必须进到"设定"去,去设定App的值
     连settings.bundle內对各控件进行设定的预设值也沒有办法一开始就直接被读取
     所以要对NSUserDefault的Key注册预设值,值的来源是Settings.Bundle的DefaultValue
     */
    if ([self settingsBundleDefaultValues])
    {
        [[NSUserDefaults standardUserDefaults] registerDefaults:[self settingsBundleDefaultValues]];
    }
    
    // 开启键盘管理
    [self setKeyboardManagerEnable:YES];
    
//    // 本地化语言
//    [LanguagesManager initialize];
//    
//    // 初始化coreData库
//    [MagicalRecord setupCoreDataStackWithStoreNamed:kRecipesStoreName];
//    
//    // 清空通知数字显示
//    [UIFactory clearApplicationBadgeNumber];
    
    // ...
}

// 用来取得Settings.Bundle各控件的预设值
+ (NSDictionary *)settingsBundleDefaultValues
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Root" ofType:@"plist" inDirectory:@"Settings.bundle"];
    if (filePath)
    {
        NSMutableDictionary *defaultDic = [NSMutableDictionary dictionary];
        
        NSURL *settingsUrl = [NSURL fileURLWithPath:filePath isDirectory:YES];
        
        NSDictionary *settingBundle = [NSDictionary dictionaryWithContentsOfURL:settingsUrl];
        
        NSArray *preference = [settingBundle objectForKey:@"PreferenceSpecifiers"];
        
        for (NSDictionary *component in preference)
        {
            NSString *key = [component objectForKey:@"Key"];
            NSString *defaultValue = [component objectForKey:@"DefaultValue"];
            
            if (!key || !defaultValue) continue;
            
            if (![component objectForKey:key])
            {
                [defaultDic setObject:defaultValue forKey:key];
            }
        }
        return defaultDic;
    }
    return nil;
}

+ (void)setKeyboardManagerEnable:(BOOL)enable
{
    // Enabling keyboard manager
    [[IQKeyboardManager sharedManager] setEnable:enable];
    
    // Resign textField if touched outside of UITextField/UITextView.
    //控制点击背景是否收起键盘
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:enable];
     // 控制是否显示键盘上的工具条
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:enable];
    
    [[IQKeyboardManager sharedManager] setShouldPlayInputClicks:NO];
    //是否显示输入框的默认文字
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:NO];
    //控制键盘上的工具条文字颜色是否用户自定义。
    if (IOS7) [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:enable];
}
@end
