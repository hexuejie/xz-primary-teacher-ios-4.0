 
//  FeedbackModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class FeedbackModel;
@protocol FeedbackModel ;
@interface FeedbackModels : Model
@property(nonatomic, strong) NSArray <FeedbackModel>*feedbacks;
@end
@interface FeedbackModel : Model
@property(nonatomic, copy) NSString * des;//副标题
@property(nonatomic, copy) NSString * name;//标题
@property(nonatomic, copy) NSString * logo;//图片地址
@property(nonatomic, copy) NSString * id;
@end
