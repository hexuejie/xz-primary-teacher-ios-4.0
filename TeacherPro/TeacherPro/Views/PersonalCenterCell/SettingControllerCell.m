//
//  SettingControllerCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/21.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "SettingControllerCell.h"
#import "PublicDocuments.h"
@interface SettingControllerCell()
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation SettingControllerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bottomLineView.backgroundColor = project_line_gray;
    self.titleLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.titleLabel.font = fontSize_14;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupCellInfo:(NSString *)text{

    self.titleLabel.text = text ;
}
@end
