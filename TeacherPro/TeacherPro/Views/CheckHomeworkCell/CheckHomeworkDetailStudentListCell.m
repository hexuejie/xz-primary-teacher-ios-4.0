//
//  CheckHomeworkDetailStudentListCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/31.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "CheckHomeworkDetailStudentListCell.h"

#import "PublicDocuments.h"
@interface CheckHomeworkDetailStudentListCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@end
@implementation CheckHomeworkDetailStudentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}
- (void)setupSubView{
    self.nameLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.nameLabel.font = fontSize_14;
    self.lineV.backgroundColor = project_line_gray;
}
- (void)setupStudentName:(NSString *)name{
    
    self.nameLabel.text = name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
