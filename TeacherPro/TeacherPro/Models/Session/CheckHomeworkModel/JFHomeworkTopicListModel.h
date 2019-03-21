//
//  JFHomeworkTopicListModel.h
//  TeacherPro
//
//  Created by DCQ on 2018/1/4.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "Model.h"
#import "AssistantsQuestionModel.h"

@class JFHomeworkChildrenModel;
@protocol JFHomeworkChildrenModel;

@interface JFHomeworkTopicListModel : Model
@property (nonatomic, strong) NSArray <JFHomeworkChildrenModel>*questions;
@end
@class QuestionModel;
@protocol QuestionModel;
@interface JFHomeworkChildrenModel :Model
@property (nonatomic, strong) NSArray <QuestionModel>*children;
@end
