//
//  SearchResultsViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/12.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

@class RepositoryModel;
typedef void(^SearchDidSelectBlock)(RepositoryModel * model,NSIndexPath * indexPath);
@interface SearchResultsViewController : BaseTableViewController<UISearchResultsUpdating>
/** 选中cell时调用此Block  */
@property (nonatomic, copy) void(^didSelectText)(NSString *selectedText);
@property (nonatomic, copy) SearchDidSelectBlock  selectedBlock;
@property(nonatomic,strong)UISearchController *searchVC;
- (void)searchMyInput:(NSString *)inputStr;
- (void)cancelSearch;
- (void)updateCellAtIndexPath:(NSIndexPath *)indexPath;
@end
