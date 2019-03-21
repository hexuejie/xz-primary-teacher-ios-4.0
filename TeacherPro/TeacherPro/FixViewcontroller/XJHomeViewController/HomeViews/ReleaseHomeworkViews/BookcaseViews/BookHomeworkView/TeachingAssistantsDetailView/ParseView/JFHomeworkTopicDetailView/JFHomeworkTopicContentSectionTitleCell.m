//
//  JFHomeworkTopicContentSectionTitleCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "JFHomeworkTopicContentSectionTitleCell.h"
#import "ProUtils.h"
#import "PublicDocuments.h"
@interface JFHomeworkTopicContentSectionTitleCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineV;

@end
@implementation JFHomeworkTopicContentSectionTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}

- (void)setupSubView{
    
    self.titleLabel.textColor = project_main_blue;
    self.titleLabel.font = fontSize_14;
    self.bottomLineV.backgroundColor = project_line_gray;
}
- (void)setupIcon:(NSString * )iconName  withTitle:(NSString *)title{
    
    self.iconImgV.image = [UIImage imageNamed:iconName] ;
    self.titleLabel.text = title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
