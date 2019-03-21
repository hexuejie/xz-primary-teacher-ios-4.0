//
//  BaseViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonConfig.h"
#import "AlertView.h"
typedef NS_ENUM(NSInteger, HUDInfoType)
{
    HUDInfoType_Success = 0,
    HUDInfoType_Failed,
    HUDInfoType_Loading,
    HUDInfoType_Uploading,
    HUDInfoType_UploadingProgress,
    HUDInfoType_NoConnectionNetwork,
    HUDInfoType_NormalShadeNo
};

@interface BaseViewController : UIViewController

@property (nonatomic,strong) UIBarButtonItem *backItem;

@property (nonatomic,assign) CGFloat pacity; 

- (void)navUIBarBackground:(CGFloat)pacity;
/**
 @ 方法描述    viewRect
 
 @ 返回参数       UIRectEdgeNone  不被覆盖  UIRectEdgeAll  需要要设置  extendedLayoutIncludesOpaqueBars 属性 为YES 覆盖  NO 不覆盖
 @ 创建人     DCQ
 */
- (UIRectEdge)getViewRect;

//
/**
 @ 方法描述    设置导航条的透明
 @ 返回参数    如果导航栏是不透明的, 默认UIViewController的View就会往下移, 在导航栏下显示, 如果不想往下移, YES 全屏View显示在导航栏挡住  NO 为下移64高度 View不会被导航栏挡住
 @ 创建人     DCQ
 */
- (BOOL )getLayoutIncludesOpaqueBars;
/**
 @ 方法描述    是否显示返回按钮
 @ 返回参数     yes
 @ 创建人     DCQ
 */
- (BOOL )getShowBackItem;
/**
 @ 方法描述    自定义导航条的显示
 @ 返回参数     NO
 @ 创建人     DCQ
 */
- (BOOL )getNavBarBgHidden;
/**
 @ 方法描述    push新的控制器到导航控制器
 @ 输入参数    viewController: 目标新的控制器对象
 @ 创建人     DCQ
 */
- (void)pushViewController:(UIViewController *)viewController;


/**
 @ 方法描述    present一个新的控制器
 @ 输入参数    viewController: 目标新的控制器对象
 @ 创建人     DCQ
 */
- (void)presentViewController:(UIViewController *)viewController modalTransitionStyle:(UIModalTransitionStyle)style completion:(void (^)(void))completion;

/**
 @ 方法描述    HUD显示文字信息
 @ 输入参数    HUDInfoType: 显示类型
 @ 创建人      DCQ
 
 */
- (void)showHUDInfoByType:(HUDInfoType)type;

/**
 @ 方法描述     上传文件进度条
 @ 输入参数     progress 进度
 @ 创建人      DCQ
 */
- (void)showUploadHUDProgress:(CGFloat )progress;
/**
 @ 方法描述    HUD显示文字信息
 @ 输入参数    String: 需要显示的文字内容
 @ 创建人      DCQ
 */
- (void)showHUDInfoByString:(NSString *)str;

/**
 @ 方法描述    隐藏HUD显示
 @ 输入参数    无
 @ 创建人      DCQ
 */
- (void)hideHUD;

/**
 @ 方法描述    设置导航栏标题
 @ 输入参数    titleStr: 标题
 @ 创建人      DCQ
 */
- (void) setNavigationItemTitle:(NSString *)titleStr;

/**
 @ 方法描述    设置导航栏标题
 @ 输入参数    titleStr: 标题 font:标题字体 titleColor:字体颜色
 @ 创建人     DCQ
 */
- (void)setNavigationItemTitle:(NSString *)titleStr titleFont:(UIFont *)font titleColor:(UIColor *)titleColor;

/**
 @ 方法描述    返回上一页
 @ 输入参数    无
 @ 创建人     DCQ
 */
- (void)backViewController;

/**
 @ 方法描述    页面是否显示tabbar
 @ 输入参数    无
 @ 创建人     DCQ
 */
- (BOOL)isShowTabarController;


/**
 @ 方法描述    判断视图是已经存在警告框
 @ 输入参数
 @ 创建人    DCQ
 */
- (BOOL)viewIsExistWarning;
/**
 @ 方法描述   显示带有图片的提示框
 @ 输入参数    operation 显示类型  content 显示详情
 @ 创建人    DCQ
 */
- (void)showAlert:(TNOperationState )operation content:(NSString *)content;
/**
 @ 方法描述   显示带有图片的提示框
 @ 输入参数    operation 显示类型  content 显示详情  itemHandler 确定按钮回调事件
 @ 创建人    DCQ
 */
- (void)showAlert:(TNOperationState )operation content:(NSString *)content block:(MMPopupItemHandler) itemHandler;

/**
 @ 方法描述   显示默认文本的提示框
 @ 输入参数    operation 显示类型  content 显示详情  items 自定义按钮  itemHandler 确定按钮回调事件 
 @ 创建人    DCQ
 */
- (void)showNormalAlertTitle:(NSString* )title content:(NSString *)content items:(NSArray *)items block:(MMPopupItemHandler) itemHandler;

/**
 @ 方法描述   显示创建班级的提示框
 @ 输入参数    operation 显示类型  content 显示详情  items 自定义按钮  itemHandler 确定按钮回调事件
 @ 创建人    DCQ
 */
- (void)showAlertCreateInputTitle:(NSString* )title content:(NSString *)content items:(NSArray *)items  placeholder:(NSString *)placeholder    handler:(MMPopupHandler)inputHandler;
/**
 @ 方法描述   显示带有默认的输入框的提示框
 @ 输入参数    operation 显示类型  content 显示详情  items 自定义按钮  placeholder 输入框的提示占位符 inputHandler 输入框输入的文字确认返回事件
 @ 创建人    DCQ
 */
- (void)showAlertNormalInputTitle:(NSString* )title content:(NSString *)content items:(NSArray *)items  placeholder:(NSString *)placeholder  handler:(MMPopupHandler)inputHandler ;

/**
 @ 方法描述   显示带输入框的输入手机号码提示框
 @ 输入参数    operation 显示类型  content 显示详情  items 自定义按钮  placeholder 输入框的提示占位符 inputHandler 输入框输入的文字确认返回事件
 @ 创建人    DCQ
 */
- (void)showAlertInputPhoneTitle:(NSString* )title content:(NSString *)content items:(NSArray *)items  placeholder:(NSString *)placeholder    handler:(MMPopupHandler)inputHandler;
/**
 @ 方法描述   显示带有右侧带按钮的输入框 提示框
 @ 输入参数    operation 显示类型  content 显示详情  items 自定义按钮  placeholder 输入框的提示占位符 inputHandler 输入框输入的文字返回事件   rightItem 自定义右侧按钮
 @ 创建人    DCQ
 */
- (void)showAlertValidationInputTitle:(NSString* )title content:(NSString *)content items:(NSArray *)items  placeholder:(NSString *)placeholder  handler:(MMPopupHandler)inputHandler textFeildRightItem:(MMPopupItem *)rightItem;

- (void)customizeNavigationInterface;
- (UIImage*) createImageWithColor: (UIColor*) color withFrame:(CGRect)rect;
@end
