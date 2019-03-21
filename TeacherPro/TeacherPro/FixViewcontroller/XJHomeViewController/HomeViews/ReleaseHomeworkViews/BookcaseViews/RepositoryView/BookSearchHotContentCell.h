//
//  BookSearchHotContentCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BookSearchHotBlock)(NSString *searchText);
@interface BookSearchHotContentCell : UITableViewCell
@property(nonatomic, copy) BookSearchHotBlock searchBlock;
+ (CGFloat)getCellHeight:(NSArray  *)array;
- (void)setupData:(NSArray *)array;
@end
