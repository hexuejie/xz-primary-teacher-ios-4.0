//
//  CheckHomeworkDetailYWDDUnitCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/31.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "CheckHomeworkDetailYWDDUnitCell.h"
#import "PublicDocuments.h"

@interface CheckHomeworkDetailYWDDUnitCell ()
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@end
@implementation CheckHomeworkDetailYWDDUnitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}
- (void)setupSubView{
    self.lineV.backgroundColor = project_line_gray;
    self.unitLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.detailLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.detailLabel.font = fontSize_14;
    self.unitLabel.font = fontSize_14;
}

- (void)setupTitle:(NSString *)unit  withNumber:(NSInteger)number{
    self.unitLabel.text = unit;
    NSString * detail = @"";
    if (number > 0) {
        detail = [NSString stringWithFormat:@"选择了%ld段",number];
    }
     self.detailLabel.text = detail;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
