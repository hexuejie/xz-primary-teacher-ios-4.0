//
//  HUDManager.m
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "HUDManager.h"
#import "AppDelegate.h"
#import "XLTieBarLoading.h"
// HUD显示文字
#define HUDAutoHideTypeShowTime             2.5                 // HUD自动隐藏模式显示的时间:2.5秒
static MBProgressHUD *HUD;
@implementation HUDManager

+ (void)showAutoHideHUDWithToShowStr:(NSString *)showStr HUDMode:(MBProgressHUDMode)mode HUDAddedToView:(UIView *)superView
{
    [self showHUDWithToShowStr:showStr HUDMode:mode autoHide:YES afterDelay:HUDAutoHideTypeShowTime userInteractionEnabled:YES HUDAddedToView:superView addProgress:0.0f];
}
+ (void)showAutoHideHUDOfCustomViewWithToShowStr:(NSString *)showStr showType:(HUDShowType)showType HUDAddedToView:(UIView *)superView addProgress:(CGFloat)progress
{
    [self showHUDWithToShowStr:showStr HUDMode:MBProgressHUDModeCustomView autoHide:YES afterDelay:HUDAutoHideTypeShowTime userInteractionEnabled:YES showType:showType HUDAddedToView:superView addProgress:progress hasShade:YES];
}
+ (void)showHUDWithToShowStr:(NSString *)showStr HUDMode:(MBProgressHUDMode)mode autoHide:(BOOL)autoHide afterDelay:(NSTimeInterval)afterDelay userInteractionEnabled:(BOOL)yesOrNo HUDAddedToView:(UIView *)superView addProgress:(CGFloat)progress
{
    [self showHUDWithToShowStr:showStr HUDMode:mode autoHide:autoHide afterDelay:afterDelay userInteractionEnabled:yesOrNo showType:HUDOthers HUDAddedToView:superView addProgress:progress hasShade:YES];
}

+ (void)showHUDWithToShowStr:(NSString *)showStr HUDMode:(MBProgressHUDMode)mode autoHide:(BOOL)autoHide afterDelay:(NSTimeInterval)afterDelay userInteractionEnabled:(BOOL)yesOrNo showType:(HUDShowType)showType HUDAddedToView:(UIView *)superView addProgress:(CGFloat)progress hasShade:(BOOL)showShadeState
{
    // 隐藏上一次显示的hud
    [self hideHUD];
    
    if (!HUD) {
         HUD = [[MBProgressHUD alloc] initWithView:superView];
         [superView addSubview:HUD];
    }
    
    HUD.userInteractionEnabled = !yesOrNo; // 加上这个属性才能在HUD还没隐藏的时候点击到别的view
    HUD.removeFromSuperViewOnHide = YES;
    HUD.mode = mode;
 
    if (mode == MBProgressHUDModeCustomView)
    {
        UIImageView *customImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        
//        if (showType == HUDOperationSuccess)
//        {
//            customImgView.image = [UIImage imageNamed:@""];
//        }
//        else if (showType == HUDOperationFailed)
//        {
//            customImgView.image = [UIImage imageNamed:@""];
//        }
        HUD.customView = customImgView;
        HUD.hidden = YES;
        if ([superView viewWithTag:232323]) {
            [XLTieBarLoading hideInView:superView];
      
        }
        [XLTieBarLoading showInView:superView  showShadeBg:showShadeState];
       
       
       
    }else if (mode == MBProgressHUDModeDeterminate){
    
        HUD.progress = progress;
         
    }
    
    HUD.label.text = showStr;
    //    HUD.color = [UIColor blackColor]
    //    HUD.taskInProgress = YES;
    HUD.animationType = MBProgressHUDAnimationZoomOut;
    
    [HUD showAnimated:YES];
    
    if (autoHide)
    {
        [HUD hideAnimated: YES afterDelay:afterDelay];
    }
}

+ (void)hideHUD
{

    [XLTieBarLoading hideInView:HUD.superview];
    [HUD hideAnimated:YES];
    [HUD removeFromSuperview];
    HUD = nil;
}

@end
