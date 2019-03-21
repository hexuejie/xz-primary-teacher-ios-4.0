//
//  BookHomeworkAssistantsTitleCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkAssistantsTitleCell.h"

#import "PublicDocuments.h"

@interface BookHomeworkAssistantsTitleCell ()
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end
@implementation BookHomeworkAssistantsTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bottomLineView.backgroundColor = project_line_gray;
}
- (void)hiddenArrow{
    
    self.arrowImgV.hidden = YES;
}
- (void)setupTitle:(NSString *)title{
    
//    self.titleLabel.textColor =  UIColorFromRGB(0x6b6b6b);
//    self.titleLabel.font = fontSize_14;
    self.titleLabel.text = title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
