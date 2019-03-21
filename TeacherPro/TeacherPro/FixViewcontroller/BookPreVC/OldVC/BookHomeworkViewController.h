//
//  BookHomeworkViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ReleaseAddBookworkCell.h"

@interface BookHomeworkViewController : BaseTableViewController


@property (nonatomic, strong) NSDictionary * backContent;
@property (nonatomic, strong) ReleaseAddBookworkCell * bottomView;
- (instancetype)initWithBookId:(NSString *)bookId withBookType:(NSString *)bookType withClear:(BOOL)isClear;
@end
