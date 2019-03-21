//
//  BookPreviewDirectoryCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookUnitModel;
@interface BookPreviewDirectoryCell : UICollectionViewCell
- (void)setupDirectoryInfo:(BookUnitModel *)model;
- (void)setupChildrenDirectoryInfo:(BookUnitModel *)model;
@end
