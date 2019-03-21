//
//  ChooseParseDescriptionCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AnalysisSelectedBlock)(NSIndexPath * indexPath);
@class QuestionAnalysisModel;
@interface ChooseParseDescriptionCell : UITableViewCell
@property(nonatomic, strong) QuestionAnalysisModel * model;
@property(nonatomic, strong) NSIndexPath * indexPath;
@property(nonatomic, copy) AnalysisSelectedBlock selectedAnalysisBlock;
- (void)setupSelectedState:(BOOL )state;
@end
