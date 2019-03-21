//
//  ClassChooseHeaderVIew.m
//  TeacherPro
//
//  Created by 何学杰 on 2018/11/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "ClassChooseHeaderVIew.h"

@implementation ClassChooseHeaderVIew

- (void)awakeFromNib{
    [super awakeFromNib];

    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.allClassButton.imageEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0);
    self.allClassButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 30);
    self.allClassButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.allClassButton.titleLabel.numberOfLines = 1;
    self.allClassButton.clipsToBounds = YES;
    self.allClassButton.titleLabel.clipsToBounds = YES;
    [self.allClassButton addTarget:self action:@selector(allClassClick:) forControlEvents:UIControlEventTouchUpInside];
    self.allClassButton.selected = NO;
    [self.allClassButton setImage:[UIImage imageNamed:@"ClassChooseHeaderVIew_all"] forState:UIControlStateNormal];
    [self.allClassButton setImage:[UIImage imageNamed:@"ClassChooseHeaderVIew_all_selected"] forState:UIControlStateSelected];
}

- (void)allClassClick:(UIButton *)button{
    
//    button.selected = !button.selected;
    
    if ([self.delegate respondsToSelector:@selector(didChooseHeader:)]) {
        [self.delegate didChooseHeader:(self)];
    }
}


@end
