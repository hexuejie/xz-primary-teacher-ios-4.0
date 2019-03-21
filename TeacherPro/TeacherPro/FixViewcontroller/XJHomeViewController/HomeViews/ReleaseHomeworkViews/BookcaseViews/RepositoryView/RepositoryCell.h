//
//  RepositoryCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RepositoryModel;
@interface RepositoryCell : UICollectionViewCell
- (void)setupRepositoryInfo:(RepositoryModel *)model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;


@end
