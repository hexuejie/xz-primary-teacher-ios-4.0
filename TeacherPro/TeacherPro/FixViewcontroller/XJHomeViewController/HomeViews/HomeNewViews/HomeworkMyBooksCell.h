//
//  HomeworkMyBooksCell.h
//  TeacherPro
//
//  Created by DCQ on 2018/5/28.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeListModel;
@class HomeBooksModel;
typedef void(^HomeworkMyBooksBlock)(HomeBooksModel * booksModel);
typedef void(^HomeworkGotoBookSelfBlock)();
@interface HomeworkMyBooksCell : UITableViewCell
@property (nonatomic, copy) HomeworkMyBooksBlock selectedBooksBlock;
@property (nonatomic, copy) HomeworkGotoBookSelfBlock bookSelfBlock;
- (void)setupHomeBooksModel:(HomeListModel *)model;
@end
