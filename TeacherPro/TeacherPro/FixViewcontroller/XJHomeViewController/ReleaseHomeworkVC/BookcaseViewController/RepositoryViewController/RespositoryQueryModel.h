//
//  RespositoryQueryModel.h
//  TeacherPro
//
//  Created by 何学杰 on 2018/11/28.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

@protocol  SubjectQueryModel;
@class  SubjectQueryModel;
@protocol  BookQueryModel;
@class  BookQueryModel;
@protocol  CartoonQueryModel;
@class  CartoonQueryModel;

@interface SubjectQueryModel :Model

@property(nonatomic, assign) BOOL isSelected;     

@property(nonatomic, copy) NSString * volume;      //教材
@property(nonatomic, copy) NSString * gradeName;
@property(nonatomic, copy) NSString * publisherId;
@property(nonatomic, copy) NSString * subject;
@property(nonatomic, copy) NSString * publisherName;
@property(nonatomic, assign) NSInteger grade;
@property(nonatomic, copy) NSString * subjectName;

@property(nonatomic, copy) NSString * level;    //绘本
@property(nonatomic, copy) NSString * position;
@end

@interface BookQueryModel :Model

@property(nonatomic, copy) NSArray * queryGrade;//<SubjectQueryModel>
@property(nonatomic, copy) NSArray * queryPublisher;
@end

@interface CartoonQueryModel :Model

@property(nonatomic, copy) NSArray * queryGrade;
@property(nonatomic, copy) NSArray * queryLevel;
@end

@interface RespositoryQueryModel : Model

@property(nonatomic, strong) NSString * bookType;
@property(nonatomic, strong) NSString * typeDes;
@property(nonatomic, strong) NSArray <SubjectQueryModel>* bookDics;
@end



NS_ASSUME_NONNULL_END
