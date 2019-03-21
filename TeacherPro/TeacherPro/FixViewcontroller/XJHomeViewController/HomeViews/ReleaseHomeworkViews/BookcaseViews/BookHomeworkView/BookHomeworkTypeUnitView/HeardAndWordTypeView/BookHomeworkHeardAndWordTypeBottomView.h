//
//  BookHomeworkHeardAndWordTypeBottomView.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SureHomeworkBlock)();
@interface BookHomeworkHeardAndWordTypeBottomView : UIView
- (void)setupTotalNumber:(NSInteger )totalNumber withWordNumber:(NSInteger)wordNumber withHeardNumber:(NSInteger)heardNumber;
@property(nonatomic, copy) SureHomeworkBlock sureBlock;
@end
