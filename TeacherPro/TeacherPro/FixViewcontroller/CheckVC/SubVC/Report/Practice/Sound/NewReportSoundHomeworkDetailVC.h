//
//  NewReportSoundHomeworkDetailVC.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/15.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "BaseNetworkViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewReportSoundHomeworkDetailVC : BaseNetworkViewController

- (instancetype)initWithHomeworkId:(NSString *)homeworkId;

@property (nonatomic,strong) NSString *subTitle;

@property (nonatomic,strong) NSArray *Items;
@property (nonatomic,assign) NSInteger currentSelected;

@property (nonatomic,assign) BOOL isSound;

@end

NS_ASSUME_NONNULL_END
