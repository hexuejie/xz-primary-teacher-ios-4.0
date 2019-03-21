//
//  BookHomeworkTypeCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, BookHomeworkType){
    BookHomeworkType_setup = 0,//设置
    BookHomeworkType_change  ,//修改
    
};
typedef void(^BookHomeworkTypeBlock)(NSIndexPath *indexPath,BookHomeworkType type);
@interface BookHomeworkTypeCell : UITableViewCell
@property(nonatomic, strong) NSIndexPath * indexPath;
@property(nonatomic, copy) BookHomeworkTypeBlock rightButtonBlock;

- (void)setupBookTitle:(NSString *)title withIsHomework:(BOOL )isHomework withImgName:(NSString *)imgName;
- (void)setupCartoonTitle:(NSString *)title   withImgName:(NSString *)imgName withState:(BOOL)isSelected;
@end
