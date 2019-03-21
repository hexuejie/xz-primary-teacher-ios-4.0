//
//  RespositoryHeaderTagView.m
//  TeacherPro
//
//  Created by 何学杰 on 2018/11/28.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "RespositoryHeaderTagView.h"

@implementation RespositoryHeaderTagView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    _tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, kScreenWidth-16-71, 22)];
    _tagLabel.textColor = HexRGB(0x8A8F99);
    _tagLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_tagLabel];
    _tagLabel.text = @"一年级/语文/北京";
    
    _queryButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-15-71 , 10, 71, 22)];
    [self addSubview:_queryButton];
    [_queryButton setTitle:@"筛选" forState:UIControlStateNormal];
    [_queryButton setImage:[UIImage imageNamed:@"respository_queryButton"] forState:UIControlStateNormal];
    [_queryButton setTitleColor:HexRGB(0x525B66) forState:UIControlStateNormal];
    _queryButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _queryButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    [_queryButton setImageEdgeInsets:UIEdgeInsetsMake(0, 50, 0, -10)];
    [_queryButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 15)];
    [_queryButton addTarget:self action:@selector(queryClick:) forControlEvents:UIControlEventTouchUpInside];;
    
}

- (void)queryClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(eespositoryHeaderClick:)]) {
        [self.delegate eespositoryHeaderClick:self];
    }
}




@end
