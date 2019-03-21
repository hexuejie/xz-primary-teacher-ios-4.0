//
//  NewCheckPictureHeaderView.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/3.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "LXBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewCheckPictureHeaderView : LXBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rangImageView;


@end

NS_ASSUME_NONNULL_END
