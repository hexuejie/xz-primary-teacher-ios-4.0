//
//  BookcaseCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/4.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BookcaseCellDeleteBlock)(NSIndexPath * index);
@class BookcaseModel;
@class RepositoryModel;
@interface BookcaseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;
@property(nonatomic, strong) NSIndexPath *index;
@property(nonatomic,copy) BookcaseCellDeleteBlock  deleteBlock;

- (void)setupBookcaseInfo:(BookcaseModel *)model isEditState:(BOOL)editing;
- (void)setupSearchItemInfo:(RepositoryModel *)model;
- (void)hasBookSelfState:(BOOL)state;
- (void)showHemoworkDetailType;
@end
