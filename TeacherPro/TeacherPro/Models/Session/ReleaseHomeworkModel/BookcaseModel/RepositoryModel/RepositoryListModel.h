 
//  ReposityoryListModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class RepositoryModel;
@protocol RepositoryModel ;
@interface RepositoryListModel : Model
@property(nonatomic, strong) NSMutableArray <RepositoryModel> *list;
@end


@interface RepositoryModel : Model
@property(nonatomic, copy) NSString * id;
@property(nonatomic, copy) NSString * bookTypeName;//书本类型


@property(nonatomic, copy) NSString * courseType;//书本类型
@property(nonatomic, copy) NSString * coverImage;//图片
@property(nonatomic, copy) NSString * name;//书本名字
@property(nonatomic, copy) NSString * bookType;//书本类型

@property(nonatomic, strong) NSNumber * hasInBookShelf;
@property(nonatomic, copy) NSString * subjectName;
@end
