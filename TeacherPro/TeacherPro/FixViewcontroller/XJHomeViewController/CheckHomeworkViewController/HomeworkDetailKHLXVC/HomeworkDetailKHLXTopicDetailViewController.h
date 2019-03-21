//
//  HomeworkDetailKHLXTopicDetailViewController.h
//  TeacherPro
//
//  Created by DCQ on 2018/1/31.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "XLButtonBarPagerTabStripViewController.h"

typedef NS_ENUM(NSInteger, HomeworkDetailKHLXTopicType){
    HomeworkDetailKHLXTopicType_Normal   = 0,
    HomeworkDetailKHLXTopicType_Complete    ,//完成 未完成 类型
    HomeworkDetailKHLXTopicType_RightAndWrong ,//正确 错误类型
};
@interface HomeworkDetailKHLXTopicDetailViewController : XLButtonBarPagerTabStripViewController
- (instancetype)initWithType:(HomeworkDetailKHLXTopicType ) type withArray:(NSArray *)studentTypeArray;
@end
