//
//  JoinClassStepOneHeaderView.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/10.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
//number  传入参数 老师的手机号
typedef void(^JoinClassStepOneHeaderViewChackButtonBlock)(NSString * number);
typedef void(^JoinClassStepOneHeaderViewChackButtonBlock)(NSString * number);
@interface JoinClassStepOneHeaderView : UIView
- (void)becomeFirstResponder;
@property(nonatomic,  copy) JoinClassStepOneHeaderViewChackButtonBlock chackBtnBlcok;
@end
