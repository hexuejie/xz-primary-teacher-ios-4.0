
//
//  HWGameTypeUnitCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/19.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWReportZXLXUnitTypeUnitCell.h"
#import "PublicDocuments.h"
@interface HWReportZXLXUnitTypeUnitCell ()
@property (weak, nonatomic) IBOutlet UILabel *typeUnitTitle;

@end
@implementation HWReportZXLXUnitTypeUnitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}
- (void)setupSubView{
    self.typeUnitTitle.font = fontSize_13;
    self.typeUnitTitle.textColor = UIColorFromRGB(0x3b3b3b);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupUnitName:(NSString *)unitName{
    self.typeUnitTitle.text = unitName;
    
}
- (void)setupInfo:(NSDictionary *)dic{
    if (dic[@"sectionName"]) {
        [self setupUnitName:dic[@"sectionName"]];
    }
    
}
@end
