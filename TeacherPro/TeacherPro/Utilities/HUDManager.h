//
//  HUDManager.h
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
typedef enum
{
    /// customView显示操作成功
    HUDOperationSuccess,
    /// customView显示操作失败
    HUDOperationFailed,
    /// 不加载customView
    HUDOthers
    
}HUDShowType;

@interface HUDManager : NSObject<MBProgressHUDDelegate>
/**
 * 方法描述: 界面提示信息展示 自动隐藏
 * 输入参数: showStr 展示文字, mode： HUD类型, 提示期间不能进行界面交互,展示类型 固定显示HUDOthers 类型 superView ：HUD 显示的父视图 
 * 返回值: VOID
 * 创建人:  DCQ
 */
+ (void)showAutoHideHUDWithToShowStr:(NSString *)showStr HUDMode:(MBProgressHUDMode)mode  HUDAddedToView:(UIView *)superView;
/**
 * 方法描述: 界面提示信息展示自动隐藏
 * 输入参数: showStr 展示文字, showType 提示展示的信息类型来源   提示期间结束后开启进行界面交互 superView ：HUD 显示的父视图 progress:进度
 * 返回值: VOID
 * 创建人:  DCQ
 */
+ (void)showAutoHideHUDOfCustomViewWithToShowStr:(NSString *)showStr showType:(HUDShowType)showType HUDAddedToView:(UIView *)superView addProgress:(CGFloat )progress;
/**
 * 方法描述: 界面提示信息展示
 * 输入参数: showStr 展示文字, showStr 展示文字, showType 提示展示的信息类型  autoHide：自动隐藏是否  afterDelay：持续时间 yesOrNo：提示期间结束后是否开启进行界面交互 superView ：HUD 显示的父视图 progress:进度
 * 返回值: VOID
 * 创建人:  DCQ
 */
+ (void)showHUDWithToShowStr:(NSString *)showStr HUDMode:(MBProgressHUDMode)mode autoHide:(BOOL)autoHide afterDelay:(NSTimeInterval)afterDelay userInteractionEnabled:(BOOL)yesOrNo HUDAddedToView:(UIView *)superView addProgress:(CGFloat )progress;
/**
 * 方法描述: 界面提示信息展示
 * 输入参数: showStr 展示文字, showStr 展示文字, showType 提示展示的信息类型  autoHide：自动隐藏是否  afterDelay：持续时间 yesOrNo：提示期间结束后是否开启进行界面交互 howType 提示展示的信息类型来源  superView ：HUD 显示的父视图 progress:进度
 * 返回值: VOID
 * 创建人:  DCQ
 */
+ (void)showHUDWithToShowStr:(NSString *)showStr HUDMode:(MBProgressHUDMode)mode autoHide:(BOOL)autoHide afterDelay:(NSTimeInterval)afterDelay userInteractionEnabled:(BOOL)yesOrNo showType:(HUDShowType)showType HUDAddedToView:(UIView *)superView addProgress:(CGFloat )progress hasShade:(BOOL)showShadeState;
/**
 * 方法描述: 隐藏提示
 * 输入参数: 无
 * 返回值:  无
 * 创建人: DCQ
 */
+ (void)hideHUD;
@end
