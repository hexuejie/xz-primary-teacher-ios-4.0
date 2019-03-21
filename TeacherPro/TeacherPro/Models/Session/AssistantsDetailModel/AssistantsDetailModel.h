//
//  AssistantsDetailModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/16.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class AssistantsPagesModel;
@class AssistantsQuestionsModel;
@class YWDDQuestionsModel;
@protocol  AssistantsPagesModel;
@protocol  AssistantsQuestionsModel;
@protocol YWDDQuestionsModel;
@interface AssistantsDetailModel : Model
@property(nonatomic, strong) NSArray <AssistantsPagesModel > *pages;
@property(nonatomic, strong) NSArray <AssistantsQuestionsModel > *questions;
@property(nonatomic, strong) NSArray <YWDDQuestionsModel> *reads;
@end

@interface AssistantsPagesModel : Model
@property(nonatomic, copy) NSString * img;
@property(nonatomic, copy) NSString * page;

@end

@interface AssistantsQuestionsModel : Model
@property(nonatomic, strong)NSArray * coord;
@property(nonatomic, copy) NSString * unitId;
@property(nonatomic, copy) NSString * page;
@property(nonatomic, copy) NSString * questionNum;
@end

@interface YWDDQuestionsModel:Model
@property(nonatomic, strong)NSArray * coord;
@property(nonatomic, copy) NSString * unitId;
@property(nonatomic, copy) NSString * page;
 
@property(nonatomic, copy) NSString * voice;//语音地址
@property(nonatomic, copy) NSString * playTime;//语音时间
@property(nonatomic, copy) NSString * id;
@end
