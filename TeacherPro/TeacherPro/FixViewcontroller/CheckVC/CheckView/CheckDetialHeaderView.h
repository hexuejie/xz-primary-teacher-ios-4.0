//
//  CheckDetialHeaderView.h
//  TeacherPro
//
//  Created by 何学杰 on 2018/12/21.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHWListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckDetialHeaderView : UIView


@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *starTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UIView *headerBottom;
@property (weak, nonatomic) IBOutlet UIButton *customBack;
@property (weak, nonatomic) IBOutlet UILabel *customTitle;
@property (weak, nonatomic) IBOutlet UIButton *customPicButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endTimeRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starTimeLeft;//42*
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTop;


@property(strong, nonatomic) CHWListModel * listModel;
@end

NS_ASSUME_NONNULL_END
