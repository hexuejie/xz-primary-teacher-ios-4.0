//
//  YWDDDetailBottomView.h
//  TeacherPro
//
//  Created by DCQ on 2018/1/19.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^YWDDDetailBlock)();

@interface YWDDDetailBottomView : UIView
@property(nonatomic, copy) YWDDDetailBlock sureBlock;
- (void)setupTitleNumber:(NSString *)titleNumber withTimer:(NSString *)timer;
- (void)setupButtonActivation:(BOOL )enabled;
- (void)setupButtonTitle:(NSString *)btnTitle;
@end
