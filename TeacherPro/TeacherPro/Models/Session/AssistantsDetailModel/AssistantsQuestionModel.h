//
//  AssistantsQuestionModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/17.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class QuestionModel;
@protocol QuestionModel;
@interface AssistantsQuestionModel : Model
@property(nonatomic, strong) QuestionModel *question;
@end


@class QuestionAnalysisModel;
@class QuestionAnalysisAudioModel;
@protocol QuestionAnalysisAudioModel;
@protocol  QuestionAnalysisModel;
@interface QuestionModel : Model
@property(nonatomic, copy)  NSString *unitId;
@property(nonatomic, copy)   NSString *questionNum;//题号
@property(nonatomic, copy)   NSString *parentQuestionNum;//父 题号
@property(nonatomic, strong) NSArray *coords;//坐标
@property(nonatomic, strong) NSArray <QuestionModel> * children;//子集
@property(nonatomic, strong) NSArray <QuestionAnalysisModel >*otherAnalysis;//他人解析
@property(nonatomic, strong) QuestionAnalysisModel *myAnalysis;//我的解析
@property(nonatomic, strong) NSString *analysis;//原书的解析

@property(nonatomic, strong) NSArray <QuestionAnalysisAudioModel> *singleAudios;//单句 音频
@property(nonatomic, strong) NSArray <QuestionAnalysisAudioModel> *continuousAudios;//连播 音频
@property(nonatomic, copy)   NSString *answer;//答案
@property(nonatomic, strong) NSArray *imgs;//图片
@property(nonatomic, copy)   NSString *questionTitle;
@property(nonatomic, copy)   NSString *analysisType;// 选择题目解析类型 bookAnalysis=原书解析,myAnalysis=我的解析,otherAnalysis=其它解析
@property(nonatomic, copy)   NSString *analysisProviderId;      //其它老师解析 提供者（老师）的id
@property(nonatomic, copy)   NSString *bookHomeworkId;//布置的作业 书本id
@property(nonatomic, copy)   NSString *bookId;//书本id
@property(nonatomic, strong)  NSArray * doubtStudents;//有疑问的学生

@property(nonatomic, strong) NSNumber  *unKnowQuestion;//用于区分该学生这题是否会做 yes 不会做 ，no 会做 用于查学生教辅题目
@end



@interface QuestionAnalysisModel : Model
@property(nonatomic, copy)   NSString *analysis;//解析文字内容
@property(nonatomic, copy)   NSString *analysisId;//解析 id
@property(nonatomic, copy)   NSString *analysisPic;////解析图片
@property(nonatomic, copy)   NSString *teacherId;//解析人id
@property(nonatomic, copy)   NSString *teacherName;//解析人名字
@end

@interface QuestionAnalysisAudioModel : Model
@property(nonatomic, copy)   NSString *voice;//音频地址
@property(nonatomic, copy)   NSString *playTime;//时长

@end
