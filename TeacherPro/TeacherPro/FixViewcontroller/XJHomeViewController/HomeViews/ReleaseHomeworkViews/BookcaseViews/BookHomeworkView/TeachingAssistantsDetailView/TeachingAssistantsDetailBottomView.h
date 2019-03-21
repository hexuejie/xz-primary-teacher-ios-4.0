//
//  TeachingAssistantsDetailBottomView.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TeachingAssistantsBlock)();
@interface TeachingAssistantsDetailBottomView : UIView
@property(nonatomic, copy) TeachingAssistantsBlock sureBlock;
- (void)setupTitleNumber:(NSString *)titleNumber withType:(NSString *)type;
- (void)setupButtonActivation:(BOOL )enabled;
- (void)setupButtonTitle:(NSString *)btnTitle;
@end
