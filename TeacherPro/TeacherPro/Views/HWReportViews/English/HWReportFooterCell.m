
//
//  HWReportFooterCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/27.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWReportFooterCell.h"
#import "PublicDocuments.h"

@interface HWReportFooterCell()
@property (weak, nonatomic) IBOutlet UIView *footerView;

@end

@implementation HWReportFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.footerView.backgroundColor = project_background_gray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
