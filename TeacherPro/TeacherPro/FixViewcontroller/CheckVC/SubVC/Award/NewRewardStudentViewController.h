//
//  NewRewardStudentViewController.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/3.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "BaseNetworkViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HomeworkCheckSuccessBlock)();

@interface NewRewardStudentViewController : BaseNetworkViewController

@property(nonatomic, copy) HomeworkCheckSuccessBlock  checkSuccessBlock;
@property (nonatomic, copy) NSString *homeworkId;

@end

NS_ASSUME_NONNULL_END
