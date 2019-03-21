//
//  RepositoryViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "RepositoryListModel.h"
#import "RepositoryCell.h"
#import "PlainFlowLayout.h"
#import "RepositorySectionView.h"
#import "BookPreviewDetailViewController.h"

#import "RepositoryBannerCell.h"
#import "RepositoryTitleCell.h"
#import "RepositoryBookViewController.h"
#import "RepositoryCartoonViewController.h"
#import "RepositoryEmptyCell.h"
#import "QueryBookFilterModel.h"
#import "RepostioryAssistantsViewController.h"
#import "RespositoryQueryModel.h"

typedef NS_ENUM(NSInteger,QueryBookFilterType){
    QueryBookFilterType_grade =  0,
    QueryBookFilterType_subjects ,
    QueryBookFilterType_types ,
    QueryBookFilterType_publishers ,
};

@interface RepositoryViewController : BaseCollectionViewController

@property(nonatomic, strong) RepositoryListModel * listModel;
@property(nonatomic, strong) NSString * grade;
@property(nonatomic, copy) NSString * subjectId;
@property(nonatomic, copy) NSString * publisherId;
@property(nonatomic, copy) NSString * level;

@property(nonatomic, assign) NSInteger selectedScreeningtType;
@property(nonatomic, copy) NSString * selectedScreeningtName;
@property(nonatomic, assign) BOOL isScrollPosition;

@property(nonatomic, assign) NSInteger selectedGradeIndex;//年级
@property(nonatomic, assign) NSInteger selectedSubjuctsIndex;//科目
@property(nonatomic, assign) NSInteger selectedTypeIndex;//类型
@property(nonatomic, assign) NSInteger selectedVersionIndex;//版本
@property(nonatomic, strong) SubjectsModel *subjectsModel;
@property(nonatomic, strong) GradesModel  *gradesModel;
@property(nonatomic, strong) BookTypesModel *typesModel;
@property(nonatomic, strong) PublishersModel *publishersModel;
@property(nonatomic, assign) QueryBookFilterType  filterType;
@property(nonatomic, assign) BOOL  isHome;
  
@property(nonatomic, strong) UIButton * editingBtn;

@property(nonatomic, copy) NSString * bookType;
@property(nonatomic, copy) BookQueryModel *bookQueryModel;
@property(nonatomic, copy) CartoonQueryModel *cartoonQueryModel;


- (instancetype)initWithFromHome:(BOOL)isHome;
@end
