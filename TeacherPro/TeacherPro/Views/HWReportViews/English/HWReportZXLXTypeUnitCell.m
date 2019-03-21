

//
//  HWReportZXLXTypeUnitCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/27.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWReportZXLXTypeUnitCell.h"
#import "PublicDocuments.h"

@interface HWReportZXLXTypeUnitCell()
@property (weak, nonatomic) IBOutlet UILabel *unitNameLabel;

@end
@implementation HWReportZXLXTypeUnitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}
- (void)setupSubView{
    self.unitNameLabel.font = fontSize_13;
    self.unitNameLabel.textColor = UIColorFromRGB(0x3b3b3b);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupUnit:(NSString *)unitName{
    
    self.unitNameLabel.text = unitName;
}
- (void)setupInfo:(NSDictionary *)dic{
    if (dic[@"unitName"]) {
        [self setupUnit:dic[@"unitName"]];
    }
   
}
@end
