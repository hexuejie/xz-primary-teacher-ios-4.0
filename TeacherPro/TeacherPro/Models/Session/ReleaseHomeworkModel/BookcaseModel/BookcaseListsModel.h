 
//  BookcaseListsModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/4.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"
@class BookcaseModel;
@protocol BookcaseModel;

@interface BookcaseListsModel : Model
@property(nonatomic, strong) NSMutableArray <BookcaseModel> *list;
@property(nonatomic, strong) NSNumber  *total;
@end

@interface BookcaseModel : Model

@property(nonatomic, copy) NSString * courseType;
@property(nonatomic, copy) NSString * bookId;
@property(nonatomic, copy) NSString * bookTypeName;//书本类型
@property(nonatomic, copy) NSString * subjectName;//科目
@property(nonatomic, copy) NSString * coverImage;//图片
@property(nonatomic, copy) NSString * name;//书本名字
@property(nonatomic, copy) NSString * bookType;//书本类型
@property(nonatomic, strong)NSArray * practiceTypes;//书本内容类型
@end
