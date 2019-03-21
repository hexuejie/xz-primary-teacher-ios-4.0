//
//  HomeworkAssitantsQuestionsListModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"
@class HomeworkAssitantsQuestionModel;
@protocol HomeworkAssitantsQuestionModel;
@interface HomeworkAssitantsQuestionsListModel : Model
@property(nonatomic, strong) NSArray <HomeworkAssitantsQuestionModel>* list;
@end
@interface HomeworkAssitantsQuestionModel : Model
@property(nonatomic, copy) NSString  * questionNum;
@property(nonatomic, copy) NSString  * unitId;
@property(nonatomic, copy) NSString  * parentQuestionNum;
@property(nonatomic, copy) NSString  * answer;//答案
@property(nonatomic, copy) NSString  * page;
@property(nonatomic, copy) NSString  * homeworkTypeId;
@property(nonatomic, strong) NSArray  * imgs;
@property(nonatomic, strong) NSArray  *doubtStudents;//有疑问的学生姓名
 
@property(nonatomic, strong) NSArray  *otherAnalysis;//他人解析
@property(nonatomic, strong) NSDictionary *myAnalysis;//我的解析
@property(nonatomic, strong) NSString *analysis;//原书的解析
@property(nonatomic, strong) NSArray   *singleAudios;//单句 音频
@property(nonatomic, strong) NSArray   *continuousAudios;//连播 音频
@property(nonatomic, strong) NSArray   *coords;//坐标点
@end
