//
//  JFHomeworkQuestionModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/25.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"
#import "AssistantsQuestionModel.h"
@class QuestionModel;
@protocol QuestionModel;
@interface JFHomeworkQuestionModel : Model
@property (nonatomic, strong) NSArray <QuestionModel>*questions;

@end
