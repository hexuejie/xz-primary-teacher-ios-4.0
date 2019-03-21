//
//  ResopositoryQueryHeadView.m
//  TeacherPro
//
//  Created by 何学杰 on 2018/11/28.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "ResopositoryQueryHeadView.h"

@implementation ResopositoryQueryHeadView


-(instancetype)init{
    if (self = [super init]){
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}


-(void)setup{
    _titleLbel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, kScreenWidth, 22)];
    [self addSubview:_titleLbel];
    _titleLbel.textColor = HexRGB(0x8A8F99);
    _titleLbel.font = [UIFont systemFontOfSize:12];
    _titleLbel.text = @"科目";
    
    _topLineView = [[UIView alloc]initWithFrame:CGRectMake(4, 0, kScreenWidth, 1)];
    [self addSubview:_topLineView];
    _topLineView.backgroundColor = HexRGB(0xF7F7F7);
}

@end
