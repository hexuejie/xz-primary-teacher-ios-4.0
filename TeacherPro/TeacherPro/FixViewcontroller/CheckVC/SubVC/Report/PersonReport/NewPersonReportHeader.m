//
//  NewPersonReportHeader.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/21.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "NewPersonReportHeader.h"

@implementation NewPersonReportHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headerLogo.layer.masksToBounds = YES;
    self.headerLogo.layer.cornerRadius = 30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
