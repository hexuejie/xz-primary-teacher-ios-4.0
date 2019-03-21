//
//  HomeworkSectionView.h
//  TeacherPro
//
//  Created by DCQ on 2018/5/28.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^HomeworkMoreBlock)();
@interface HomeworkSectionView : UITableViewHeaderFooterView
@property(nonatomic, copy) HomeworkMoreBlock moreBlock;
- (void)setupSectionTitle:(NSString *)title;
- (void)setupMoreBtnState:(BOOL)isShow;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBottom;//12

@end
