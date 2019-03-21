//
//  HomeworkDetailKHLXListModel.h
//  TeacherPro
//
//  Created by DCQ on 2018/2/1.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class HomeworkDetailKHLXQuestionsModel;
@protocol HomeworkDetailKHLXQuestionsModel;
@interface HomeworkDetailKHLXListModel : Model
@property(nonatomic, strong) NSArray <HomeworkDetailKHLXQuestionsModel>* questions;
@end

@class  AnswerStudentsModel;
@protocol AnswerStudentsModel;
@interface HomeworkDetailKHLXQuestionsModel : Model
@property(nonatomic, copy) NSString *  unitId;//单元id
@property(nonatomic, copy) NSString * questionNum;//题号
@property(nonatomic, copy) NSString * questionType;//题目类型代码
@property(nonatomic, copy) NSString * questionTypeName;//题目类型中文
@property(nonatomic, copy) NSString * questionStem;//题目
@property(nonatomic, copy) NSString * difficultyName;//难度
@property(nonatomic, strong) NSDictionary  * options;//选项题 内容
@property(nonatomic, strong) NSNumber * questionDuration;//问题时间
@property(nonatomic, strong) NSNumber * cellHeight;
@property(nonatomic, strong) NSNumber * useCount;//使用次数
@property(nonatomic, strong) NSNumber * totalStudent;//学生总数
@property(nonatomic, strong) NSNumber * errorStudentCount;//错误学生
@property(nonatomic, strong) NSNumber * finishStudentCount;//完成学生人数
@property(nonatomic, strong) NSArray <AnswerStudentsModel>* answerStudents;
@end

@interface AnswerStudentsModel : Model
@property(nonatomic, copy) NSString *studentId;
@property(nonatomic, copy) NSString *studentName;
@property(nonatomic, strong) NSNumber * score;
@property(nonatomic, strong) NSNumber *correct;
@end
