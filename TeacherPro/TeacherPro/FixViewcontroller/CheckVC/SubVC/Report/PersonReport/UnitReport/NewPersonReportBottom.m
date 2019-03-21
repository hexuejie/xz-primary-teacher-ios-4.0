//
//  NewPersonReportBottom.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/23.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "NewPersonReportBottom.h"

@implementation NewPersonReportBottom

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layerView1.layer.cornerRadius = 23;
    self.layerView1.layer.masksToBounds = YES;
    self.layerView1.layer.borderWidth = 1.0;
    self.layerView1.layer.borderColor = HexRGB(0x8A8F99).CGColor;
    
    self.layerView2.layer.cornerRadius = 23;
    self.layerView2.layer.masksToBounds = YES;
    self.layerView2.layer.borderWidth = 1.0;
    self.layerView2.layer.borderColor = HexRGB(0x8A8F99).CGColor;
    
    self.layerView3.layer.cornerRadius = 23;
    self.layerView3.layer.masksToBounds = YES;
    self.layerView3.layer.borderWidth = 1.0;
    self.layerView3.layer.borderColor = HexRGB(0x8A8F99).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
