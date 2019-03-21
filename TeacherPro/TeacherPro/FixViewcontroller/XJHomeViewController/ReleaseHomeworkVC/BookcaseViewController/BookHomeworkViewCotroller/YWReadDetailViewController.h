//
//  YWReadDetailViewController.h
//  TeacherPro
//
//  Created by DCQ on 2018/1/18.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseNetworkViewController.h"
@class BookPreviewDetailModel;
@interface YWReadDetailViewController : BaseNetworkViewController


- (instancetype)initWithBookId:(NSString *)bookId withUnitId:(NSString *)unitId  withBookName: (NSString *)bookName withBookInfo:(BookPreviewDetailModel*)detailBookModel withCacheData:(NSArray *)cacheData ;
@end
