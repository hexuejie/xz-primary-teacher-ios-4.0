//
//  QueryBookFilterModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/27.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class SubjectModel;
@protocol  SubjectModel;
@interface SubjectsModel :Model
@property(nonatomic, strong) NSArray <SubjectModel>* subjects;
@end
@interface SubjectModel :Model
@property(nonatomic, copy) NSString * subjectId;
@property(nonatomic, copy) NSString * subjectName;
@end

@class BookTypeModel;
@protocol  BookTypeModel;
@interface BookTypesModel :Model
@property(nonatomic, strong) NSArray <BookTypeModel>* bookTypes;
@end
@interface BookTypeModel :Model
@property(nonatomic, copy) NSString * bookType;
@property(nonatomic, copy) NSString * bookTypeName;
@end


@class PublisherModel;
@protocol  PublisherModel;
@interface PublishersModel :Model
@property(nonatomic, strong) NSArray <PublisherModel>* publishers;
@end
@interface PublisherModel :Model
@property(nonatomic, strong) NSNumber * id;
@property(nonatomic, copy) NSString * name;//全称
@property(nonatomic, copy) NSString * versionName;//简写
@end

@class GradeModel;
@protocol  GradeModel;
@interface GradesModel :Model
@property(nonatomic, strong) NSArray <GradeModel>* grades;
@end
@interface GradeModel :Model
@property(nonatomic, strong) NSNumber * grade;
@property(nonatomic, copy) NSString * gradeName;
@end


@class QueryBookFilterModel;
@protocol  QueryBookFilterModel;
@interface QueryBookFilterListModel :Model
@property(nonatomic, strong) NSArray <QueryBookFilterModel>* dics;
@end
@interface QueryBookFilterModel :Model
@property(nonatomic, strong) NSNumber * grade;
@property(nonatomic, copy) NSString * gradeName;
@property(nonatomic, copy) NSString * bookType;
@property(nonatomic, copy) NSString * bookTypeName;
@property(nonatomic, copy) NSString * subject;
@property(nonatomic, copy) NSString * subjectName;
@property(nonatomic, copy) NSString * publisherId;
@property(nonatomic, copy) NSString * publisherName;
@end

