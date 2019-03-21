//
//  RespostioryMenuQueryItem.m
//  TeacherPro
//
//  Created by 何学杰 on 2018/11/28.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "RespostioryMenuQueryItem.h"

@implementation RespostioryMenuQueryItem


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];

    }
    return self;
}

- (void)setup{
    self.contentView.layer.cornerRadius = 4.0;
    self.contentView.layer.masksToBounds = YES;
    
    _titleLabel = [[UILabel alloc]initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.lineBreakMode = NSLineBreakByClipping;
    _titleLabel.numberOfLines = 0;
    _titleLabel.text = @"46546";
    
    self.contentView.backgroundColor = HexRGB(0xf4f4f4);
    _titleLabel.textColor = HexRGB(0x4D4D4D);
    
//    self.contentView.backgroundColor = HexRGB(0x2DB5FF);
//    _titleLabel.textColor = HexRGB(0xffffff);
    
    if (_titleLabel.text.length>5) {
        _titleLabel.font = [UIFont systemFontOfSize:11];
    }else{
        _titleLabel.font = [UIFont systemFontOfSize:12];
    }
    
}

@end
