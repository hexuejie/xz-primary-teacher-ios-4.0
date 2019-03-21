 
//  StudentHomeworkDetailModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@interface StudentHomeworkDetailModel : Model


@property(nonatomic, strong) NSNumber *ctime ;//- 作业布置时间
@property(nonatomic, strong) NSNumber *status ;// - 作业状态 0：进行中 1：待点评 9:结束
@property(nonatomic, strong) NSNumber *finishTime ;// - 作业完成时间
@property(nonatomic, copy) NSString *scoreLevel ;// 作业得分等级
@property(nonatomic, strong) NSNumber *coin;// - 作业获取的A豆数量
@property(nonatomic, copy) NSString *text;// - 作业的文本信息
@property(nonatomic, strong) NSArray *photos ;//- 作业的图片信息
@property(nonatomic, copy) NSString *sound ;//- 作业的语音信息
@property(nonatomic, strong) NSArray * bookHomeworks ;// - 书本作业
@property(nonatomic, copy) NSString * homeworkFeedback;//作业反馈方式
@property(nonatomic, copy) NSString * feedbackSound;//学生反馈语音
@property(nonatomic, strong) NSArray * feedbackPhotos;//学生反馈图片
@property(nonatomic, copy) NSString * studentFeedback;//学生反馈方式


@property(nonatomic, strong)NSNumber *hasKhlxHomeworks;//是否有课后练习
@property(nonatomic, strong)NSNumber *rightQuestCount;//做对数
@property(nonatomic, strong)NSNumber *errorQuestCount;//做错数
@property(nonatomic, strong)NSNumber *hasJFHomeworks;//是否有教辅不会做
@property(nonatomic, strong)NSArray *unknowQuestions;//教辅不会做题目
@end
