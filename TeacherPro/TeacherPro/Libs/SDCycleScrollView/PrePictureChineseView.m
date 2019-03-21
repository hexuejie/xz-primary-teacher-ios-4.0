//
//  PrePictureChineseView.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/30.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "PrePictureChineseView.h"

@implementation PrePictureChineseView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.layer.masksToBounds
}
- (IBAction)bgClick:(id)sender {
    [self removeFromSuperview];
}

@end
