//
//  RepositoryScreeningView.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/19.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger, RepositoryScreeningType){
    RepositoryScreeningType_grade       = 0,
    RepositoryScreeningType_subjects       ,
    RepositoryScreeningType_type           ,
    RepositoryScreeningType_version        ,
};

@class BookTypesModel;
@class PublishersModel;
@class SubjectsModel;
@class GradesModel;
@protocol RepositoryScreeningViewDelegate;
@interface RepositoryScreeningView : UIView
 
@property (nonatomic, assign) NSInteger rows;
@property(nonatomic, strong) BookTypesModel * typesModel;
@property(nonatomic, strong) PublishersModel *publishersModel;
@property(nonatomic, strong) SubjectsModel * subjectsModel;
@property(nonatomic, strong) GradesModel * gradesModel;
@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, copy)  NSString * publisherId;
@property(nonatomic,assign) RepositoryScreeningType screeningType;
@property(nonatomic, assign) id<RepositoryScreeningViewDelegate> delegate;
- (void)updateTableView;
- (void)showView;
- (void)hideView;
@end

@protocol RepositoryScreeningViewDelegate <NSObject>
- (void)selectedType:(RepositoryScreeningType)type withIndexItem:(id)item withIndex:(NSInteger )selectedIndex;
- (void)hiddScreeningView;
@end
