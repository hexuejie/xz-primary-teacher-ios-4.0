//
//  JFTopicOtherTeacherParseModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/22.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"
@class JFTopicTeacherParseModel;
@protocol JFTopicTeacherParseModel;
@interface JFTopicOtherTeacherParseModel : Model
@property(nonatomic,strong) NSArray <JFTopicTeacherParseModel> *analysis;
@end
@interface JFTopicTeacherParseModel : Model
@property(nonatomic,strong) NSNumber *praiseTeacherCount ;
@property(nonatomic,strong) NSNumber *hasPraise ;
@property(nonatomic,copy) NSString *analysis ;//内容
@property(nonatomic,copy) NSString *analysisId ;
 
@property(nonatomic,copy) NSString *analysisPic;//图片
@property(nonatomic,copy) NSString *teacherId;//解析人id
@property(nonatomic,copy) NSString *teacherName;//解析人名
@end
