//
//  HomeworkSuspensionView.h
//  TeacherPro
//
//  Created by DCQ on 2018/8/22.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HomeworkSuspensionTouchType) {
   HomeworkSuspensionTouchType_Advertising = 0 ,
   HomeworkSuspensionTouchType_check      ,//检查
   HomeworkSuspensionTouchType_release    ,//发布
    HomeworkSuspensionTouchType_huigu
};

typedef void(^HomeworkSuspensionTouchBlock)(HomeworkSuspensionTouchType type);
@interface HomeworkSuspensionView : UITableViewHeaderFooterView
@property (copy, nonatomic)  HomeworkSuspensionTouchBlock touckBlock;

@property (weak, nonatomic) IBOutlet UIView *segementView;

@end
