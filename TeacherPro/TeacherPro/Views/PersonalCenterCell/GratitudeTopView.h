//
//  GratitudeTopView.h
//  TeacherPro
//
//  Created by DCQ on 2018/1/9.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TopViewGiftMallBlock)();
typedef void(^TopViewRulesBlock)();
@interface GratitudeTopView : UIView
@property(nonatomic, copy) TopViewGiftMallBlock giftMallBtnBlock;
@property(nonatomic, copy) TopViewRulesBlock  rulesBtnBlock;
- (void)setupNumber:(NSString *)number;
@end
