//
//  NewCheckHomeworkDetailVC.h
//  TeacherPro
//
//  Created by 何学杰 on 2018/12/20.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseNetworkViewController.h"
#import "CHWListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,  CheckHomeworkDetailVCType) {
    CheckHomeworkDetailVCType_normal =  0,
    CheckHomeworkDetailVCType_check      ,//检查
    CheckHomeworkDetailVCType_look       ,//查看
    
    
};

@interface NewCheckHomeworkDetailVC : BaseNetworkViewController

//////////////绘本 没有勋章列表
@property(copy, nonatomic) NSString  * homeworkId;
@property(strong, nonatomic) CHWListModel * listModel;
//@property(assign, nonatomic) CheckHomeworkDetailVCType  style;
@property(strong, nonatomic) NSNumber *onlineHomework;
@property (assign, nonatomic) CheckHomeworkDetailVCType detailVCTyp;

@property (assign, nonatomic) BOOL isphonicsHomework;

- (instancetype)initHomeworkID:(NSString *)homeworkId  withType:(CheckHomeworkDetailVCType )type withOnlineHomework:(NSNumber *)onlineHomework;
@end

NS_ASSUME_NONNULL_END
