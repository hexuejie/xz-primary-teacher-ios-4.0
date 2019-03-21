//
//  ContentAddressSchoolCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ContentAddressSchoolCell.h"
#import "PublicDocuments.h"
@interface ContentAddressSchoolCell ()
@property (weak, nonatomic) IBOutlet UILabel *schoolName;
@property (weak, nonatomic) IBOutlet UILabel *clazzNumber;

@end
@implementation ContentAddressSchoolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.schoolName.textColor = UIColorFromRGB(0x6b6b6b);
    self.schoolName.font = fontSize_15;
    self.clazzNumber.font = fontSize_13;
    self.clazzNumber.textColor = UIColorFromRGB(0x9f9f9f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupSchoolModel:(AddressSchoolModel *)model{

    if (model) {
        self.clazzNumber.text = [NSString stringWithFormat:@"已有%@个班级",model.clazzCount];
        self.schoolName.text = [NSString stringWithFormat:@"%@",model.schoolName];
        self.clazzNumber.font = fontSize_12;
        self.schoolName.font = fontSize_14;
    }
}
@end
