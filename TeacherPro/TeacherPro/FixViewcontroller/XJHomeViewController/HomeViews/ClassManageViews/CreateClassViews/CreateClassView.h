//
//  CreateClassView.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassManageModel.h"
typedef NS_ENUM(NSInteger, ClassViewFromType) {

    ClassViewFromType_normal  = 0,
    ClassViewFromType_create     ,//创建班级
    ClassViewFromType_choose     ,//选择班级
    ClassViewFromType_checkChoose ,//检查作业选择班级
};
typedef void(^CreateClassViewBlock)(NSString * gradeName);
typedef void(^ChooseClassBlock)(NSDictionary * classInfo);
typedef void(^CheckChooseClassBlock)(ClassManageModel * classInfo);
@interface CreateClassView : UIView
@property(nonatomic, copy) CreateClassViewBlock createBlock;
@property(nonatomic, copy) ChooseClassBlock chooseBlock;
@property(nonatomic, copy) CheckChooseClassBlock checkChooseBlock;
@property(nonatomic, copy) NSString  *gradeName;
- (void)reloadData:(ClassManageListModel *)listModel;
- (instancetype)initWithFrame:(CGRect)frame withType:(ClassViewFromType) fromType;
@end
