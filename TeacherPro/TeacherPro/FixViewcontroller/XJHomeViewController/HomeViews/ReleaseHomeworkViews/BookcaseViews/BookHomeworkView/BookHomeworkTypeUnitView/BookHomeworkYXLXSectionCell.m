//
//  BookHomeworkYXLXSectionCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkYXLXSectionCell.h"
#import "PublicDocuments.h"


@interface BookHomeworkYXLXSectionCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
@implementation BookHomeworkYXLXSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}
- (void)setupSubview{

    self.titleLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.titleLabel.font = fontSize_14;
    self.lineView.backgroundColor = project_line_gray;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupUnitName:(NSString *)unitName{

    self.titleLabel.text = unitName;
}
@end
