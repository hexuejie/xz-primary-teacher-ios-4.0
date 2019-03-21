//
//  BookHomeworkSectionView.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BookHomeworkSectionClearBlock)();
@interface BookHomeworkSectionView : UITableViewHeaderFooterView
@property(nonatomic, copy)BookHomeworkSectionClearBlock clearBlock;
- (void)setupEditState:(BOOL )isEdit;
- (void)setupBookTitle:(NSAttributedString *)attributedStr withEditState:(BOOL )isEdit;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//绘本
@end
