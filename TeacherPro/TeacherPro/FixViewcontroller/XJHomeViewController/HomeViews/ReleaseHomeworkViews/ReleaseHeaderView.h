//
//  ReleaseHeaderView.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/14.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReleaseHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *iconTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *iconlineView;
@property (weak, nonatomic) IBOutlet UIView *topLineView;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *moreBookButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toplineHeight;
@property (weak, nonatomic) IBOutlet UIView *viewBackgrgoud;

@end
