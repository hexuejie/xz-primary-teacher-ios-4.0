//
//  AssistantsQuestionItemTitleCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/10.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeworkAssitantsQuestionModel;
@interface AssistantsQuestionItemTitleCell : UICollectionViewCell
- (void)setupItemContent:(HomeworkAssitantsQuestionModel *)model;
@end
