//
//  NewProblemTextItem.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/24.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "LXBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewProblemTextItem : LXBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

NS_ASSUME_NONNULL_END
