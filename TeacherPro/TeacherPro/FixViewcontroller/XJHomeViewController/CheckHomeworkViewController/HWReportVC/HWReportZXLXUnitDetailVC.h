//
//  HWReportUnitDetailVC.h
//  TeacherPro
//
//  Created by DCQ on 2018/7/19.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

typedef  NS_ENUM(NSInteger, HWReportZXLXUnitDetailStyle){
    HWReportZXLXUnitDetailStyle_normal = 0,
    HWReportZXLXUnitDetailStyle_words ,
    HWReportZXLXUnitDetailStyle_listenAndTalk
};
@class MultilayerItem;
@interface HWReportZXLXUnitDetailVC : BaseTableViewController
- (instancetype)initWithStyle:(HWReportZXLXUnitDetailStyle )style withDic:(NSDictionary *)items withTitle:(NSString *)titleStr;
@end
