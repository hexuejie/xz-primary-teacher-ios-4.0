//
//  CheckDetialTipsView.m
//  TeacherPro
//
//  Created by 何学杰 on 2018/12/26.
//  Copyright © 2018 ZNXZ. All rights reserved.
//

#import "CheckDetialTipsView.h"

@implementation CheckDetialTipsView


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.BottomView.clipsToBounds = YES;
    self.BottomView.layer.cornerRadius = 6.0;
}

- (IBAction)cancelButtonClick:(id)sender {
    [self removeFromSuperview];
}

@end
