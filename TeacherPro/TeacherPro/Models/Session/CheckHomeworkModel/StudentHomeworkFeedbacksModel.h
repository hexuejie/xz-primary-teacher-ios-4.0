 
//  StudentHomeworkFeedbacksModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class StudentFeedbackModel;
@protocol StudentFeedbackModel <NSObject>
@end
@interface StudentHomeworkFeedbacksModel : Model
@property(nonatomic, strong) NSArray <StudentFeedbackModel>*feedbacks;
@end
@interface StudentFeedbackModel :Model

@property(nonatomic, copy) NSString  *sex;
@property(nonatomic, copy) NSString  *avatar;

@property(nonatomic, copy) NSString  *studentName;//反馈的学生姓名
@property(nonatomic, copy) NSString  *homeworkFeedback; // 作业的反馈方式
@property(nonatomic, strong) NSArray  *feedbackPhotos;// : List - 反馈的照片信息
@property(nonatomic, copy) NSString  *feedbackSound; // 反馈的音频信息

@end
