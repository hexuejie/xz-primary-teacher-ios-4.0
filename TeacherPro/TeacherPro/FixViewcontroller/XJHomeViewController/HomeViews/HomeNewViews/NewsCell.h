//
//  NewsCell.h
//  TeacherPro
//
//  Created by DCQ on 2018/5/28.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeNewsModel;
@interface NewsCell : UITableViewCell
- (void)setupNewsModel:(HomeNewsModel *)model;
@end
