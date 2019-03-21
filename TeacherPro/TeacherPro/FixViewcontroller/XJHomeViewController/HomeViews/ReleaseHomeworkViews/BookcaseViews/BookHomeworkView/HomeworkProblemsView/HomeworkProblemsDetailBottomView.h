//
//  HomeworkProblemsDetailBottomView.h
//  TeacherPro
//
//  Created by DCQ on 2018/1/22.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomeworkProblemsBottomBtnBlock)();
@interface HomeworkProblemsDetailBottomView : UIView
@property(nonatomic,copy) HomeworkProblemsBottomBtnBlock sureBlock;
- (void)setupTitleNumber:(NSString *)titleNumber withTimer:(NSString *)timer;
- (void)setupNomarlTitle:(NSString *)title;
- (void)setupButtonActivation:(BOOL )enabled;
- (void)setupButtonTitle:(NSString *)title;
@end
