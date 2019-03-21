//
//  CourseModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/16.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class CourseModel;
@protocol  CourseModel ;

@interface CoursesModel : Model
@property(nonatomic, strong) NSArray <CourseModel >* items;

@end
@interface CourseModel : Model
//key
@property(nonatomic, copy) NSString * dicKey ;
//key 类型
@property(nonatomic, copy) NSString * dicType ;
//值
@property(nonatomic, copy) NSString * dicValue ;

@property(nonatomic, strong) NSNumber * orderNum ;


@end
