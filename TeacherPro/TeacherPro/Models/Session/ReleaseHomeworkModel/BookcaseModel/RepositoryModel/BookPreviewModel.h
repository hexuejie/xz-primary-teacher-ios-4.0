 
//  BookPreviewModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class BookPreviewDetailModel;

@interface BookPreviewModel : Model
@property(nonatomic, strong) BookPreviewDetailModel *book;
@end

@class BookUnitModel;
@protocol BookUnitModel;
@class PracticeTypeModel;
@protocol PracticeTypeModel;

@interface BookPreviewDetailModel : Model
@property(nonatomic, strong) NSArray <PracticeTypeModel>* practiceTypes;//书本作业类型

@property(nonatomic, copy) NSString *courseType;////phonics_textbook
@property(nonatomic, copy) NSString *bookType;////三种类型  绘本书  教辅
@property(nonatomic, copy) NSString *bookTypeName;
@property(nonatomic, strong) NSArray <BookUnitModel>* bookUnits;

@property(nonatomic, copy) NSString * level;
@property(nonatomic, copy) NSString * cartoonType;
@property(nonatomic, copy) NSString * coverImage;
@property(nonatomic, copy) NSString * ctime;

@property(nonatomic, copy) NSString *publisherName;//出版社
@property(nonatomic, copy) NSString *name;//书名
@property(nonatomic, copy) NSString *subjectName;//科目名

@property(nonatomic, strong) NSString * intro;//简介
@end


@interface PracticeTypeModel :Model
@property(nonatomic,  copy) NSString *practiceType;//简写
@property(nonatomic,  copy) NSString *practiceTypeDes;//描写
@property(nonatomic,  copy) NSString *isOnline;// 是否在线作业  true   false

@property(nonatomic,  copy) NSString * practiceIntro;//简介
@end

@class ChildrenUnitModel;
@protocol ChildrenUnitModel;
@interface BookUnitModel :Model
@property(nonatomic,  copy) NSString *unitId;//单元名字
@property(nonatomic,  copy) NSString *unitName;//单元名字

@property(nonatomic,  strong) NSNumber *wordCount;//单词数
@property(nonatomic,  strong) NSArray <ChildrenUnitModel>* children;
@property(nonatomic,  strong) NSNumber * hasFollow;//是否有跟读
@property(nonatomic,  strong) NSNumber *hasWord;//是否有单词
@property(nonatomic,  strong) NSNumber *hasListen;//是否有听说
@property(nonatomic,  strong) NSNumber *hasExercise;//是否有题
@property(nonatomic,  strong) NSNumber *hasRead;//是否有语文点读题目

@end

@interface  ChildrenUnitModel: Model;
@property(nonatomic,  copy) NSString *unitId;//单元名字
@property(nonatomic,  copy) NSString *unitName;//单元名字
@property(nonatomic,  strong) NSNumber *wordCount;//单词数
@property(nonatomic,  strong) NSNumber * hasFollow;//是否有跟读
@property(nonatomic,  strong) NSNumber *hasWord;//是否有单词
@property(nonatomic,  strong) NSNumber *hasListen;//是否有听说
@property(nonatomic,  strong) NSNumber *hasExercise;//是否有题
@property(nonatomic,  strong) NSNumber *hasRead;//是否有语文点读题目
@end
