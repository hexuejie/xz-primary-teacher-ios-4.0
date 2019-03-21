//
//  RepositoryBookViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/18.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseCollectionViewController.h"
@class SubjectsModel;
@class GradesModel;
@class BookTypesModel;
@class PublishersModel;
@interface RepositoryBookViewController : BaseCollectionViewController
@property(nonatomic, strong) SubjectsModel *subjectsModel;
@property(nonatomic, strong) GradesModel  *gradesModel;

@property(nonatomic, strong) PublishersModel *publishersModel;
@end
