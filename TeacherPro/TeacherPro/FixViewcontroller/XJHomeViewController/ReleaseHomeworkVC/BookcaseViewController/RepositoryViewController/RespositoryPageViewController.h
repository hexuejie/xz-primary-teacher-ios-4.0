//
//  RespositoryPageViewController.h
//  TeacherPro
//
//  Created by 何学杰 on 2018/11/27.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "ESPageViewController.h"
//#import "RepositoryListModel.h"
//#import "QueryBookFilterModel.h"
#import "RespositoryQueryModel.h"



@interface RespositoryPageViewController : ESPageViewController

//@property(nonatomic, strong) RepositoryListModel * listModel;
@property(nonatomic, strong) NSArray <RespositoryQueryModel*>*bookTypeArray;


@property(nonatomic, strong) NSNumber * grade;
@property(nonatomic, copy) NSString * subjectId;
@property(nonatomic, copy) NSString * bookType;
@property(nonatomic, copy) NSString * publisherId;
@property(nonatomic, assign) NSInteger selectedScreeningtType;
@property(nonatomic, copy) NSString * selectedScreeningtName;

//@property(nonatomic, strong) PublishersModel *publishersModel;
//@property(nonatomic, strong) SubjectsModel *subjectsModel;
@property(nonatomic, strong) BookQueryModel *bookQueryModel;
@property(nonatomic, strong) CartoonQueryModel *cartoonQueryModel ;

//@property(nonatomic, assign) QueryBookFilterType  filterType;
@end

