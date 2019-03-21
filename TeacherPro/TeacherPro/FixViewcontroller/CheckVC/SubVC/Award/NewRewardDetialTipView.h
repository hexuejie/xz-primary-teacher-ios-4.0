//
//  NewRewardDetialTipView.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/4.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "LXBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewRewardDetialTipView : LXBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *finishButton;


@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

NS_ASSUME_NONNULL_END
