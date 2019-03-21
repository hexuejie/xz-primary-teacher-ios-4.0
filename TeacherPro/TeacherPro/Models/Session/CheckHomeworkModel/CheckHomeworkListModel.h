 
//  CheckHomeworkListModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class CheckHomeworkModel;
@protocol CheckHomeworkModel
@end
@interface CheckHomeworkListModel : Model
@property (nonatomic, strong) NSMutableArray <CheckHomeworkModel >*homeworks;
@property (nonatomic, strong) NSNumber * totalCount;//总记录数
@end
@interface CheckHomeworkModel : Model

@property(nonatomic, copy) NSString *isphonicsHomework;
@property(nonatomic, copy) NSString *hasCallHomework;//已催缴
@property(nonatomic, copy) NSString *homeworkId;      //作业id
@property(nonatomic, copy) NSString *clazzId;         //班级id
@property(nonatomic, copy) NSString *clazzName;       //班级名称
@property(nonatomic, strong) NSString *ctime;          //作业布置时间
@property(nonatomic, strong) NSString *endTime;        //作业截止时间
@property(nonatomic, strong) NSNumber *status;         //  作业状态 (0：进行中 1：待点评 9:结束）

@property(nonatomic, copy) NSString *feedbackName;          // 反馈方式名称
@property(nonatomic, strong) NSNumber *studentCount;        //   学生人数
@property(nonatomic, strong) NSNumber *finishedCount ;      //   作业完成人数
@property(nonatomic, copy) NSString *gradeName;             // 年级
@property(nonatomic, strong) NSArray *books;                // 书本信息
@property(nonatomic, copy) NSString *subjectId ;            // 科目id
@property(nonatomic, copy) NSString *subjectName ;          // 科目名称
@property(nonatomic, strong) NSNumber *hasReport;        //  是否有报告
@property(nonatomic, strong)NSNumber *onlineHomework;//true为在线 no未非在线
@end
