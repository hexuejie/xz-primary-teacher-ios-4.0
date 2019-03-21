//
//  CheckDetialReusableView.m
//  TeacherPro
//
//  Created by 何学杰 on 2018/12/24.
//  Copyright © 2018 ZNXZ. All rights reserved.
//

#import "CheckDetialReusableView.h"

@implementation CheckDetialReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.isFirst = YES;
}

- (void)setIsFirst:(BOOL)isFirst{
    _isFirst = isFirst;
    if (_isFirst) {
        _courseName.hidden = NO;
        _finishTagTop.constant = 50;
    }else{
        _courseName.hidden = YES;
        _finishTagTop.constant = 3;
        
    }
}

@end
