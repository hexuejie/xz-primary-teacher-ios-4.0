//
//  TeachingAssistantsListItemChooseCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/18.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuestionModel;
typedef void(^AssistantsListItemChooseBlock)(NSIndexPath * indexPath);
@interface TeachingAssistantsListItemChooseCell : UITableViewCell
@property(nonatomic,strong) NSIndexPath * indexPath;
@property(nonatomic, copy) AssistantsListItemChooseBlock chooseBlock;
- (void)setupModel:(QuestionModel *)model isChoose:(BOOL)chooseState;
@end
