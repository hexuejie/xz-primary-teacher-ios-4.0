//
//  TeachingAssistantsDetailViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseNetworkViewController.h"
@class BookPreviewDetailModel;
@interface TeachingAssistantsDetailViewController : BaseNetworkViewController
- (instancetype)initWithBookId:(NSString *)bookId withUnitId:(NSString *)unitId  withBookName: (NSString *)bookName withBookInfo:(BookPreviewDetailModel*)detailModel;
@end
