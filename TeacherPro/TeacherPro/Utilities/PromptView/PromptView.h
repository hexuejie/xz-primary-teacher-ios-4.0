//
//  PromptView.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchButton.h"
#import "PublicDocuments.h"
@interface PromptView : UIView

+ (void)dismissAlertView;

+ (void)removeAlertView;
+ (void)showrResultViewWithTitle:(NSString *)title content:(NSString *)content cancelButtonTitle:(NSString *)cancelT sureButtonTitle:(NSString *)sureT withDoneBlock:(TouchBlock)doneblock withCancelBlock:(TouchBlock)cancelBlock;


 


/**
 邀请函
 */

+ (void)showInvitationResultViewWithContent:(NSString *)content withDoneBlock:(TouchBlock)doneblock withCancelBlock:(TouchBlock)cancelblock ;

//创建班级
+ (void)showTextFeildViewWithTitle:(NSString *)title content:(NSString *)content withPlaceholder:(NSString *)placeholder  withDoneBlock:(NewClassSureTouchBlock)doneblock withCancelBlock:(TouchBlock)cancelBlock;
//转让班级
+ (void)showTransferTextFeildViewWithTitle:(NSString *)title content:(NSString *)content withPlaceholder:(NSString *)placeholder  withDoneBlock:(NewClassSureTouchBlock)doneblock withCancelBlock:(TouchBlock)cancelBlock;
//解散班级
+ (void)showDissolutionTextFeildViewWithTitle:(NSString *)title content:(NSString *)content withPlaceholder:(NSString *)placeholder  withDoneBlock:(NewClassSureTouchBlock)doneblock withCancelBlock:(TouchBlock)cancelBlock withCodeBtnTouchBlock:(TouchBlock)codeTouchBlock;
@end
