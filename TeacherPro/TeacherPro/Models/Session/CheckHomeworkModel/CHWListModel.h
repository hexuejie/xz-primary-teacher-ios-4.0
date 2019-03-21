//
//  CHWListModel.h
//  TeacherPro
//
//  Created by DCQ on 2018/7/20.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
@class CHWInfoModel;
@protocol  CHWInfoModel;
@interface CHWListModel : Model
@property(nonatomic, strong) CHWInfoModel * info;
@end


@interface CHWInfoModel : Model
@property(nonatomic, strong) NSNumber * sendCoin;//是否发感恩币
@property(nonatomic, copy) NSString *gradeName;//年级
@property(nonatomic, copy) NSString *feedback;//反馈类型
@property(nonatomic, copy) NSString *feedbackName;//反馈名字

@property(nonatomic, copy) NSString *ctime;//开始时间
@property(nonatomic, copy) NSString *endTime;//结束时间
@property(nonatomic, copy) NSString *subjectName;//科目
@property(nonatomic, copy) NSString * clazzName;//班级
@property(nonatomic, copy) NSString * subjectId;//科目编码

@property(nonatomic, strong) NSNumber * studentCount;//学生总数
@property(nonatomic, strong) NSNumber * finishedCount;//完成人数
@property(nonatomic, strong)  NSArray * homeworkItems;
 
@end



