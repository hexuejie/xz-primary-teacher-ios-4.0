//
//  StudentKHLXHomeworkDetailModel.h
//  TeacherPro
//
//  Created by DCQ on 2018/2/2.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "Model.h"
@class StudentKHLXHomeworkDetailModel;
@protocol StudentKHLXHomeworkDetailModel;
@interface StudentKHLXHomeworkDetailListModel : Model
@property(nonatomic, strong) NSArray <StudentKHLXHomeworkDetailModel>* unitQuestions;
@end
@class  StudentKHLXHomeworkDetailQuestionModel;
@protocol StudentKHLXHomeworkDetailQuestionModel;
@interface StudentKHLXHomeworkDetailModel : Model

@property(nonatomic, strong) NSNumber * errorQuestCount;//错误的
@property(nonatomic, strong) NSNumber * rightQuestCount;//正确的
@property(nonatomic, copy) NSString *  unitId;
@property(nonatomic, copy) NSString * unitName;
@property(nonatomic, copy) NSString * nameNo;
@property(nonatomic, strong) NSArray <StudentKHLXHomeworkDetailQuestionModel>* questions;
@property(nonatomic, strong) NSNumber * expectTime;//一个单元总时间
@end


@interface StudentKHLXHomeworkDetailQuestionModel : Model
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

@property(nonatomic, strong) NSNumber * errorStudentCount;//错误的学生数
@property(nonatomic, strong) NSNumber * finishStudentCount;//完成的学生数

@property(nonatomic, strong) NSNumber *studentStatus;//-1=未做，1=做错,2=做对
@end
