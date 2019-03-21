//
//  ClassChooseTableViewCell.h
//  TeacherPro
//
//  Created by 何学杰 on 2018/11/19.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassChooseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class ClassChooseTableViewCell;

@protocol ClassChooseTableViewCellDelegate <NSObject>

- (void)didChooseButtonCell:(ClassChooseTableViewCell *)cell ChooseItem:(ClassChooseCollectionViewCell *)item;

@end

@interface ClassChooseTableViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *classViews;
@property (nonatomic, strong) NSMutableArray *classArray;
@property (nonatomic,weak) id<ClassChooseTableViewCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
