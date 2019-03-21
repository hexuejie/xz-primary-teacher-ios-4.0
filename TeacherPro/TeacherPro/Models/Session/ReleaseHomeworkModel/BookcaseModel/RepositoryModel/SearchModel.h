 
//  SearchModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"
@class SearchModel;
@protocol SearchModel ;
@interface SearchsModel : Model
@property(nonatomic, strong) NSArray <SearchModel > *items;

@end
@interface SearchModel : Model
@property(nonatomic, copy) NSString * name;
@property(nonatomic, copy) NSString * id;
@end
