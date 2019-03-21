//
//  NewPersonReportItemCell.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/22.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "LXBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewPersonReportItemCell : LXBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *leftPlayerButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;




@property (weak, nonatomic) IBOutlet UIView *chooseBackView;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton1;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton2;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton3;

@end

NS_ASSUME_NONNULL_END
