//
//  ClassChooseCollectionViewCell.m
//  TeacherPro
//
//  Created by 何学杰 on 2018/11/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "ClassChooseCollectionViewCell.h"

@implementation ClassChooseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.ClassChooseButton setBackgroundColor:HexRGB(0xF4F4F4)];
    [self.ClassChooseButton addTarget:self action:@selector(classChooseClick:) forControlEvents:UIControlEventTouchUpInside];
    self.ClassChooseButton.layer.masksToBounds = YES;
    self.ClassChooseButton.layer.cornerRadius = 4.0;
}

- (void)classChooseClick:(UIButton *)button{
    button.selected = !button.selected;
    
    self.isSelected = button.selected;
    if ([self.delegate respondsToSelector:@selector(didChooseButton:)]) {
        [self.delegate didChooseButton:(self)];
    }
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    
    _model.isSelected = _isSelected;
    _ClassChooseButton.selected = _isSelected;
    if (self.ClassChooseButton.selected) {
        [self.ClassChooseButton setBackgroundColor:HexRGB(0x2DB5FF)];
    }else{
        [self.ClassChooseButton setBackgroundColor:HexRGB(0xF4F4F4)];
    }
}

- (void)setModel:(ClassManageModel *)model{
    _model = model;
    
    [self.ClassChooseButton setTitle:_model.clazzName forState:UIControlStateNormal];
    self.isSelected = _model.isSelected;
}

@end
