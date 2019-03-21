//
//  ClassChooseCollectionViewCell.h
//  TeacherPro
//
//  Created by 何学杰 on 2018/11/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "ClassManageModel.h"
#import <UIKit/UIKit.h>

@class ClassChooseCollectionViewCell;

@protocol ClassChooseCollectionViewCellDelegate <NSObject>

- (void)didChooseButton:(ClassChooseCollectionViewCell *)cell;

@end

@interface ClassChooseCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *ClassChooseButton;
@property (nonatomic,weak)id<ClassChooseCollectionViewCellDelegate>delegate;

@property (nonatomic,strong) ClassManageModel *model;
@property(nonatomic, assign) BOOL     isSelected ; // 学校id
@end
