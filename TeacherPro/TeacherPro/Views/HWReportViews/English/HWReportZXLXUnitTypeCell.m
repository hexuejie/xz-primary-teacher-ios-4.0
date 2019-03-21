
//
//  HWReportZXLXUnitTypeCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/27.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWReportZXLXUnitTypeCell.h"
#import "PublicDocuments.h"

@interface HWReportZXLXUnitTypeCell()
@property (weak, nonatomic) IBOutlet UILabel *unitTypeLabel;

@end
@implementation HWReportZXLXUnitTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}
- (void)setupSubView{
    self.unitTypeLabel.font = fontSize_13;
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupUnitTypeName:(NSString *)typeName{
    self.unitTypeLabel.text = typeName;
}
- (void)setupInfo:(NSDictionary *)dic{
    if (dic[@"type"]) {
        [self setupUnitTypeName:dic[@"type"]];
    } 
}
@end
