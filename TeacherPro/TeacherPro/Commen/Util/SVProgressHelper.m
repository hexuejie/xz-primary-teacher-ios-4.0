//
//  SVProgressHelper.m
//  eShop
//
//  Created by Kyle on 15/1/5.
//  Copyright (c) 2015年 yujiahui. All rights reserved.
//

#import "SVProgressHelper.h"
//#import "NoticeHelp.h"
#import "TeacherPro-Swift.h"

@implementation SVProgressHelper


#pragma mark
#pragma mark SVProgressHUD method
+ (void)showHUD
{
    [SVProgressHUD showProgress:-1 status:nil maskType:SVProgressHUDMaskTypeNone];
}
+ (void)showHUDWithStatus:(NSString *)msg
{
    [SVProgressHUD showProgress:-1 status:msg maskType:SVProgressHUDMaskTypeNone];
}

+ (void)showAllHUDStatus:(NSString *)msg{
//    [SVProgressHUD showProgress:-1 status:msg maskType:SVProgressHUDMaskTypeClear];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showProgress:-1 status:msg];
}

+ (void)showAllHUDNotClick{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD show];
}

+ (void)showHUDImage:(UIImage *)image status:(NSString *)msg
{
    [SVProgressHUD showImage:image status:msg];
}

+ (void)dismissHUD
{
    [SVProgressHUD dismiss];
}

+ (void)dismissWithMsg:(NSString *)msg
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [self dismissWithImage:nil msg:msg];
}


+ (void)dismissWithImage:(UIImage *)image msg:(NSString *)msg
{
    [SVProgressHUD showImage:image status:msg];
}

+ (void)dismissHUDSuccess:(NSString *)msg
{
    [SVProgressHUD showSuccessWithStatus:msg];
}
+ (void)dismissHUDError:(NSString *)msg
{
    [SVProgressHUD showErrorWithStatus:msg];
}

+(void)setHUDTitleFont:(UIFont *)font TitleColor:(UIColor *)titleColor backGroundColor:(UIColor *)backGroundColor{
   
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    if (font != nil) {
        [SVProgressHUD setFont:font];
    }
    if (titleColor != nil) {
        [SVProgressHUD setForegroundColor:titleColor];
    }
    if (titleColor != nil) {
        [SVProgressHUD setBackgroundColor:backGroundColor];
    }
    
}

+ (void)dismissWithCustomMessage:(NSString *)msg{
    [self customDismiss:true message:msg];
}

+(void)customDismiss:(BOOL)isCorrect message:(NSString *)msg{
    [self customDismiss:isCorrect message:msg complete:nil];
}

+(void)customDismiss:(BOOL)isCorrect message:(NSString *)msg complete:(void (^)())complete{
    [SVProgressHUD dismiss];
    
    UIImage *image = nil;
    if(isCorrect){
        image = [UIImage imageNamed:@"hud_success"];
    }else{
        image = [UIImage imageNamed:@"hud_success"];;
    }
    
//    LXMessageHUDView *hud = [[LXMessageHUDView alloc] initWithImage:image message:msg];
//    [NoticeHelp showCustomPopViewController:hud duration:1.0 complete:^{
//        if (complete != nil){
//            complete();
//        }
//    }];
    
}



@end
