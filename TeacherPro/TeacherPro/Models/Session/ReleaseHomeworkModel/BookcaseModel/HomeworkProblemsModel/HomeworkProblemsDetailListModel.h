//
//  HomeworkProblemsDetailListModel.h
//  TeacherPro
//
//  Created by DCQ on 2018/1/22.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "Model.h"
@class HomeworkProblemsDetailModel;
@protocol HomeworkProblemsDetailModel;
@interface HomeworkProblemsDetailListModel : Model
@property(nonatomic, strong) NSArray <HomeworkProblemsDetailModel>* unitQuestions;
@end
@class  HomeworkProblemsQuestionsModel;
@protocol HomeworkProblemsQuestionsModel;
@interface HomeworkProblemsDetailModel : Model
@property(nonatomic, copy) NSString *  unitId;
@property(nonatomic, copy) NSString * unitName;
@property(nonatomic, copy) NSString * nameNo;
@property(nonatomic, strong) NSArray <HomeworkProblemsQuestionsModel>* questions;
@property(nonatomic, strong) NSNumber * expectTime;//一个单元总时间
@end


@interface HomeworkProblemsQuestionsModel : Model
@property(nonatomic, copy) NSString *  unitId;//单元id
@property(nonatomic, copy) NSString * questionNum;//题号
@property(nonatomic, copy) NSString * questionType;//题目类型代码
@property(nonatomic, copy) NSString * questionTypeName;//题目类型中文
@property(nonatomic, copy) NSString * questionStem;//题目
@property(nonatomic, copy) NSString * difficultyName;//难度
@property(nonatomic, strong) NSDictionary *options;//选项题 内容
@property(nonatomic, strong) NSNumber * questionDuration;//问题时间
@property(nonatomic, strong) NSNumber * cellHeight;
@property(nonatomic, strong) NSNumber * useCount;//使用次数
@end
