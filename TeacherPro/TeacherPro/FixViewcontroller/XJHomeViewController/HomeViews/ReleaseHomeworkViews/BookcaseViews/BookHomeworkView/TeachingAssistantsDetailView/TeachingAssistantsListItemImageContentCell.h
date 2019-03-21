//
//  TeachingAssistantsListItemImageContentCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuestionModel;
@class QuestionChildrenModel;
typedef void(^AssistantsItemDetailButtonBlock)(NSIndexPath * index, CGFloat height);
@interface TeachingAssistantsListItemImageContentCell : UITableViewCell
@property(nonatomic, copy) AssistantsItemDetailButtonBlock  detailBlock;
@property(nonatomic, strong) NSIndexPath * indexPath;
@property(nonatomic, assign) CGFloat defaultHeight;
- (void)setupModel:(QuestionModel *)model withImgHeight:(CGFloat) height withIndex:(NSInteger)index;
- (void)setupButtonState:(BOOL)state;
@end
