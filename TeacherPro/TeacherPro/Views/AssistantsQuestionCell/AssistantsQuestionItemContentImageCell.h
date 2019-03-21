//
//  AssistantsQuestionItemContentImageCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/10.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeworkAssitantsQuestionModel ;
@interface AssistantsQuestionItemContentImageCell : UICollectionViewCell
- (void)setupItemContent:(HomeworkAssitantsQuestionModel *)model withHeight:(CGFloat )heght withIndexPath:(NSInteger) index;
@end
