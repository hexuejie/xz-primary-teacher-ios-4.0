//
//  NewPersonProblemDetialVC.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/24.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "BaseNetworkViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewPersonProblemDetialVC : BaseNetworkViewController

@property (strong, nonatomic) NSDictionary  * parameterDic;


@property (nonatomic,strong) NSArray *dataDic;
@property (nonatomic,strong) NSArray *Items;
@property (nonatomic,assign) NSInteger currentSelected;
@end

NS_ASSUME_NONNULL_END
