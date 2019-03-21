//
//  ReleaseHomeworkTimeViewMask.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/25.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "ReleaseHomeworkTimeViewMask.h"

@implementation ReleaseHomeworkTimeViewMask

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    _pickBottom.locale = locale;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
