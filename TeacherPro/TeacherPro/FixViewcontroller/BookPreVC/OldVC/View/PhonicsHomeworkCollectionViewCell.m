//
//  PhonicsHomeworkCollectionViewCell.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/7.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "PhonicsHomeworkCollectionViewCell.h"

@implementation PhonicsHomeworkCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (_isSelected) {
        _titleLabel.textColor = HexRGB(0xffffff);
        self.contentView.backgroundColor = HexRGB(0x2DB5FF);
    }else{
         _titleLabel.textColor = HexRGB(0x4D4D4D);
        self.contentView.backgroundColor = HexRGB(0xF4F4F4);
    }
}

- (void)setModel:(ChildrenUnitModel *)model{
    _model = model;
    _titleLabel.text = _model.unitName;
}

@end
