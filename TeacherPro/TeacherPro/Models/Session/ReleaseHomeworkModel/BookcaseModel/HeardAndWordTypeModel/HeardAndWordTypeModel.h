 
//  HeardAndWordTypeModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class WordTypeModel;
@class ListenAndTalkModel;
@protocol WordTypeModel ;
@protocol ListenAndTalkModel ;
@interface HeardAndWordTypeModel : Model
@property(nonatomic, copy)NSString * unitName;
@property(nonatomic, strong)NSArray <WordTypeModel>* words;
@property(nonatomic, copy)NSString * unitId;
@property(nonatomic, strong)NSArray <ListenAndTalkModel>*listenAndTalk;
@end

@class AppTypesModel;
@protocol AppTypesModel;
@interface WordTypeModel : Model
@property(nonatomic, strong)NSArray<AppTypesModel> * appTypes;
@property(nonatomic, copy)NSString * sectionName;
@property(nonatomic, copy)NSString * id;
@end

@class AppTypesModel;
@protocol AppTypesModel;
@interface ListenAndTalkModel : Model
@property(nonatomic, strong)NSArray <AppTypesModel> * appTypes;
@property(nonatomic, copy)NSString * sectionName;
@property(nonatomic, copy)NSString * id;
@end

@interface AppTypesModel : Model
@property(nonatomic, copy)NSString * logo;//图片
@property(nonatomic, copy)NSString * typeEn;//类型简写
@property(nonatomic, copy)NSString * typeCn;//类型中文描述
@property(nonatomic, strong)NSNumber * durationTime;//时长
@property(nonatomic, strong) NSNumber * count;//多少句
@end
