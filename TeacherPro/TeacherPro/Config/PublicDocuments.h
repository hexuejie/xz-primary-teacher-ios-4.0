//
//  PublicDocuments.h
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#ifndef PublicDocuments_h
#define PublicDocuments_h



/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~班级最少 0人以上才能发放奖励   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#define MinSendCoinStudentsNumber    0   //废除该控制 。有服务器控制能否发放奖励

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~型号~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
// 设备相关
#define isIPad                      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isIPhone                    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
// 判断设备型号
#define iPhone4                     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5                     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6                     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus                 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//#define iPhoneX                 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneX                 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define IOS6                        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) // 判断是否是IOS6的系统
#define IOS7                        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) // 判断是否是IOS7的系统
#define IOS8                        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) // 判断是否是IOS8的系统
#define IOS9                        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) // 判断是否是IOS9的系统
#define IOS10                        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) // 判断是否是IOS10的系统
#define IOS11                        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) // 判断是否是IOS11的系统
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
// 动态获取设备高度
#define IPHONE_HEIGHT               [UIScreen mainScreen].bounds.size.height
#define IPHONE_WIDTH                [UIScreen mainScreen].bounds.size.width

// block self
#define WEAKSELF                    typeof(self) __weak weakSelf = self;
#define STRONGSELF                  typeof(weakSelf) __strong strongSelf = weakSelf;

#define PHONEX_HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0)
#define tn_tabbat_height (iPhoneX?(49.f + PHONEX_HOME_INDICATOR_HEIGHT):49.0f)
//#define tn_tabbat_height  self.tabBarController.tabBar.frame.size.height
#define NavigationBar_Height (self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height)
#define NavigationStatusBar_Height [[UIApplication sharedApplication] statusBarFrame].size.height

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~字体~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#define scale_y (iPhone4? 1:(IPHONE_HEIGHT/568))
#define scale_x (iPhone4? 1:(IPHONE_WIDTH/320))
#define ip6size 1.2f
#define FITSCALE(parameter) (parameter*(iPhoneX?ip6size:scale_y))



#define fontSize_22  ((iPhone6Plus||iPhoneX)? [UIFont systemFontOfSize:22*ip6size]:[UIFont systemFontOfSize:FITSCALE(22)])
#define fontSize_20  ((iPhone6Plus||iPhoneX)? [UIFont systemFontOfSize:20*ip6size]:[UIFont systemFontOfSize:FITSCALE(20)])
#define fontSize_18  ((iPhone6Plus||iPhoneX)? [UIFont systemFontOfSize:18*ip6size]:[UIFont systemFontOfSize:FITSCALE(18)])
#define fontSize_17  ((iPhone6Plus||iPhoneX)? [UIFont systemFontOfSize:17*ip6size]:[UIFont systemFontOfSize:FITSCALE(17)])
#define fontSize_16  [UIFont systemFontOfSize:17 weight:UIFontWeightMedium]
#define fontSize_15  ((iPhone6Plus||iPhoneX)? [UIFont systemFontOfSize:15*ip6size]:[UIFont systemFontOfSize:FITSCALE(15)])
#define fontSize_14  ((iPhone6Plus||iPhoneX)? [UIFont systemFontOfSize:14*ip6size]:[UIFont systemFontOfSize:FITSCALE(14)])
#define fontSize_13  ((iPhone6Plus||iPhoneX)? [UIFont systemFontOfSize:13*ip6size]:[UIFont systemFontOfSize:FITSCALE(13)])
#define fontSize_12  ((iPhone6Plus||iPhoneX)? [UIFont systemFontOfSize:12*ip6size]:[UIFont systemFontOfSize:FITSCALE(12)])
#define fontSize_11  ((iPhone6Plus||iPhoneX)? [UIFont systemFontOfSize:11*ip6size]:[UIFont systemFontOfSize:FITSCALE(11)])
#define fontSize_10  ((iPhone6Plus||iPhoneX)? [UIFont systemFontOfSize:10*ip6size]:[UIFont systemFontOfSize:FITSCALE(10)])

#define tn_tabbar_font [UIFont systemFontOfSize:10]
#define  UILABEL_LINE_SPACE  6
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~颜色~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#define rightBarButtonItem_font   [UIFont systemFontOfSize:16]
#define tn_tabbar_select_color    UIColorFromRGB(0x33AAFF)
#define tn_tabbar_unselect_color UIColorFromRGB(0xC6C6C6)
#define tn_background_gray      UIColorFromRGB(0xf5f5f5)

#define titleColor_gray      UIColorFromRGB(0x4D4D4D)

//转换16进制颜色
#define UIColorFromRGB(rgbValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])

#define tn_lighter_gray         UIColorFromRGB(0xCCCCCC)
#define tn_border_color         UIColorFromRGB(0xE5E5E5)
#define tn_dark_gray            UIColorFromRGB(0x333333)

#define view_background_color                 [UIColor  whiteColor]  //viewController的背景色

#define project_main_blue       UIColorFromRGB(0x33AAFF)
#define project_main_white       UIColorFromRGB(0xffffff)
//#define project_main_blue     UIColorFromRGB(0x2e65fd)
#define project_border_color    UIColorFromRGB(0xDEE1E7)
#define project_textgray_white  UIColorFromRGB(0x919499)
#define project_textgray_gray   UIColorFromRGB(0x6b6b6b)

#define project_background_gray   UIColorFromRGB(0xF6F6F8)
#define project_line_gray         UIColorFromRGB(0xf7f7f7)
#define btn_cornerRadius 2.0f

#define BooksPlaceholderImgName  @"homework_book_normal.png" //书本默认加载图片

#define BookTypeCartoon  @"CartoonNew" //书本默认加载图片   /绘本
#define BookTypeBook  @"Book" //教材  包含：自然拼图
#define BookTypeBookJF  @"JFBook" //教辅
#define BookTypePhonics @"Phonics"//自然拼读

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ key ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#define  PLEASELOGIN_NotificationKey                     @"PLEASELOGIN_NotificationKey"

#define  UPDATACITY_NotificationKey                     @"UPDATACITY_NotificationKey"

#define  UPDATE_CLASS_TEACHER_LIST                  @"UPDATE_CLASS_TEACHER_LIST"//更新班级详情 老师列表
#define  UPDATE_CLASS_STUDENT_LIST                  @"UPDATE_CLASS_STUDENT_LIST"

#define SESSIONMSG_KEY                              @"SESSIONMSG_KEY"
#define UPDATE_BINDINGCLASS                         @"UPDATE_BINDINGCLASS"//更新老师绑定班级管理

#define UPDATE_SEARCH_CLASS_LIST                         @"UPDATE_SEARCH_CLASS_LIST"//更新搜索班级列表

#define UPDATE_INVITATION_CLASS_LIST                         @"UPDATE_INVITATION_CLASS_LIST"//更新邀请加入列表




#define  UPDATE_CHECKLIST_TEARCHER_COIN       @"UPDATE_CHECKLIST_TEARCHER_COIN" //更新检查列表和感恩币
//~~~~~消息
#define NEWS_TYPE_APPLY_MESSAGE               @"NEWS_TYPE_APPLY_MESSAGE" //申请消息
#define NEWS_TYPE_RECEIVED_MESSAGE           @"NEWS_TYPE_RECEIVED_MESSAGE" //收到消息
#define NEWS_TYPE_SENDER_MESSAGE            @"NEWS_TYPE_SENDER_MESSAGE"//发送消息
#define NEWS_TYPE_HOMEWORK_MESSAGE          @"NEWS_TYPE_HOMEWORK_MESSAGE"//作业消息
#define NEWS_TYPE_SYSTEM_MESSAGE            @"NEWS_TYPE_SYSTEM_MESSAGE"//系统消息
#define NEWS_TYPE_INVITATION_MESSAGE         @"NEWS_TYPE_INVITATION_MESSAGE"//邀请消息


//~~~~~~~布置作业
#define HOMEWORK_CONTENT_PATH                 @"HOMEWORK_CONTENT_PATH"//布置作业内容路径
#define GAME_PRACTICE_MEMORY_KEY              @"GAME_PRACTICE_MEMORY_KEY"//游戏练习作业存储
#define TKWLY_PRACTICE_MEMORY_KEY             @"TKWLY_PRACTICE_MEMORY_KEY"//听课文录音
#define LDKW_PRACTICE_MEMORY_KEY             @"LDKW_PRACTICE_MEMORY_KEY"//朗读课文
#define DCTX_PRACTICE_MEMORY_KEY             @"DCTX_PRACTICE_MEMORY_KEY"//单词听写
#define KHLX_PRACTICE_MEMORY_KEY             @"KHLX_PRACTICE_MEMORY_KEY"//课后练习
#define YWDD_PRACTICE_MEMORY_KEY             @"YWDD_PRACTICE_MEMORY_KEY"//语文点读
#define UNIT_KHLX_PRACTICE_MEMORY_KEY        @"UNIT_KHLX_PRACTICE_MEMORY_KEY"//选择的单元的课后练习

#define SAVE_RELEASEHOMEWORKCLASS           @"SAVE_RELEASEHOMEWORKCLASS"// 发布作业选择的班级 存储 key

#define SAVE_JFHomework_Choose_Topic_Parsing       @"SAVE_JFHomework_Choose_Topic_Parsing"   //教辅作业选择题目解析

#define  BOOK_HOMEWORK_ADD_NEW       @"BOOK_HOMEWORK_ADD_NEW" //新增一本书作业
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~提示文字~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#define AlertTitle                      @"温馨提示"
#define Cancel                          @"取消"
#define Confirm                         @"确定"

#define NoConnectionNetwork             @"当前网络不可用,请检查您的网络设置"
#define Loading                         @""
#define LoginLoading                    @"登录中..."
#define LoadingFinish                   @"完成"
#define LoadFailed                      @"加载失败"
#define SaveFailed                      @"保存失败"

#define OperationFailure                @"操作失败,请重试"
#define OperationSuccess                @"操作成功"

#define DeprecatedYourInputInfo         @"是否放弃您所输入的信息?"

#define NotLogin                        @"您还没有登录或者登录已过期,请登录"

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#define max_dou                 5
#define min_dou                 -5
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
//QQ分享
#define  kQQAppKey  @"1106012795"
//微信
#define  kWXAppKey  @"wx02aa55ec6b60ff24"

//极光
#define JPushAppKey   @"b2a4e9df7a570a7b8b27fceb" 

//友盟统计
#define UMengAppKey   @"598809ccbbea8372f80015b8"

//bugly 统计
#define BuglyAppKey   @"caa418d17f"

#define kRecordAudioFile    @"myRecord.caf"
#define kMyselfRecordFile   @"myselfRecord.mp3"



#define CustomerServicePhoneNumber   @"400-853-0661"//客服电话
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

// NSlog
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#endif /* PublicDocuments_h */
