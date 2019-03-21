//
//  HomeListModel.h
//  TeacherPro
//
//  Created by DCQ on 2018/7/2.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class HomeBooksModel;
@protocol HomeBooksModel;
@class HomeNewsModel;
@protocol HomeNewsModel;
@class HomeSysAdvertsModel;
@protocol HomeSysAdvertsModel;

@interface HomeListModel : Model
@property(nonatomic, strong) NSMutableArray <HomeBooksModel> *books;
@property(nonatomic, strong) NSMutableArray <HomeNewsModel > *news;
@property(nonatomic, strong) NSMutableArray <HomeSysAdvertsModel> *sysAdverts;
@end
@interface HomeBooksModel : Model

@property(nonatomic, copy) NSString * courseType;
@property(nonatomic, copy) NSString * bookId;
@property(nonatomic, copy) NSString * bookTypeName;//书本类型
@property(nonatomic, copy) NSString * subjectName;//科目
@property(nonatomic, copy) NSString * coverImage;//图片
@property(nonatomic, copy) NSString * name;//书本名字
@property(nonatomic, copy) NSString * bookType;//书本类型
@property(nonatomic, strong)NSArray * practiceTypes;//书本内容类型
@property(nonatomic, copy) NSString * volume;//上下册
@end
@interface HomeNewsModel : Model
@property(nonatomic, copy) NSString * title;//标题
@property(nonatomic, strong) NSNumber *  readCount;//阅读数
@property(nonatomic, strong) NSNumber * newsId;//新闻id
@property(nonatomic, strong) NSArray * coverUrlArray;//图片
@property(nonatomic, copy) NSString * newsUrl;// 新闻地址
@property(nonatomic, copy) NSString * shareTitle;//分享标题
@property(nonatomic, copy) NSString * shareLogo;//分享图标
@property(nonatomic, copy) NSString * shareUrl;//分享链接
@property(nonatomic, copy) NSString * shareDesc;//分享描述

@end
@interface HomeSysAdvertsModel : Model
@property(nonatomic, copy) NSString * adName;//标题
@property(nonatomic, strong) NSNumber * adId;//广告id
@property(nonatomic, copy) NSString * adUrl;//图片地址
@property(nonatomic, copy) NSString * redirectUrl;// 内容地址
@end
