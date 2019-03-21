//
//  NewReportListonTableViewCell.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/11.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "NewReportListonTableViewCell.h"

@implementation NewReportListonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.priceLabel1.textColor = HexRGB(0x8A8F99);
    self.priceLabel2.textColor = HexRGB(0x8A8F99);
    self.priceLabel3.textColor = HexRGB(0x8A8F99);
    self.priceLabel4.textColor = HexRGB(0x8A8F99);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
