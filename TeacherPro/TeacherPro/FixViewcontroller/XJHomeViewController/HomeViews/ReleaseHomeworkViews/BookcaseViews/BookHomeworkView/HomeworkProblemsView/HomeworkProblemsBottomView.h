//
//  HomeworkProblemsBottomView.h
//  TeacherPro
//
//  Created by DCQ on 2018/1/22.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ HomeworkProblemsBottomButtomBlock)();
@interface HomeworkProblemsBottomView : UIView
@property(nonatomic, copy) HomeworkProblemsBottomButtomBlock btnActionBlock;
@end
