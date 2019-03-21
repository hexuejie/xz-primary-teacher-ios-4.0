//
//  JFTopicParseItemOriginalCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AnalysisSelectedBlock)(NSIndexPath * indexPath);
@interface JFTopicParseItemOriginalCell : UITableViewCell
@property(nonatomic, strong) NSIndexPath * indexPath;
@property(nonatomic, copy) AnalysisSelectedBlock selectedAnalysisBlock;
- (void)setupSelectedState:(BOOL )state;
- (void)setupTextCell:(NSString *)analysis;
@end
