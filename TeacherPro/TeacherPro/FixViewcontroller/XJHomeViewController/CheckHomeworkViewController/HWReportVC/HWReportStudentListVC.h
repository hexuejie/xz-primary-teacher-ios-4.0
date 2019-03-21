//
//  HWReportStudentListVC.h
//  TeacherPro
//
//  Created by DCQ on 2018/7/25.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger,HWReportStudentListVCStyle){
    HWReportStudentListVCStyle_normal = 0,
    HWReportStudentListVCStyle_ywdd,
    HWReportStudentListVCStyle_cartoon
};
@interface HWReportStudentListVC : BaseTableViewController
- (instancetype)initWithHomeworkId:(NSString * )homeworkId withHomeworkTypeId:(NSString *)homeworkTypeId withStyle:(HWReportStudentListVCStyle) style withBookId:(NSString *)bookId;
@end
