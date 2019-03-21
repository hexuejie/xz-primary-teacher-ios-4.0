//
//  BookHomeworkItemCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//
//书本章节下的单项
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BookHomeworkItemType){
    BookHomeworkItemType_word = 0,
    BookHomeworkItemType_heard ,
};
@class AppTypesModel;
@interface BookHomeworkItemCell : UICollectionViewCell
- (void)setupItem:(AppTypesModel *)model withIconImgName:(NSString *)imgName withType:(BookHomeworkItemType )type;
- (void)setupChooseState:(BOOL )selected;
@end
