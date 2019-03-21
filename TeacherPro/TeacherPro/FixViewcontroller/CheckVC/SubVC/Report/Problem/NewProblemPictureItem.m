//
//  NewProblemPictureItem.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/24.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "NewProblemPictureItem.h"

@implementation NewProblemPictureItem

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.pictureRight.layer.cornerRadius = 4.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
