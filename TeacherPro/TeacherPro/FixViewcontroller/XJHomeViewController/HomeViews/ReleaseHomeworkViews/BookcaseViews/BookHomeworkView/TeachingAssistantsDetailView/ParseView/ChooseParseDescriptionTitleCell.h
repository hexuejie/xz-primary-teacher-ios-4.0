//
//  ChooseParseDescriptionTitleCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuestionAnalysisModel;
typedef void(^ChooseParseEditBlock)(NSIndexPath * indexPath);
typedef void(^ChooseParseChooseBlock)(NSIndexPath * indexPath);

@interface ChooseParseDescriptionTitleCell : UITableViewCell
@property(nonatomic, strong) NSIndexPath * indexPath;
@property(nonatomic, copy) ChooseParseEditBlock editBlock;
@property(nonatomic, copy) ChooseParseChooseBlock chooseBlock;
- (void)setupModel:(QuestionAnalysisModel *)model isChooseState:(BOOL)chooseState;
- (void)setupChooseState:(BOOL)chooseState;

-(void)setupDefaultMyParseTitle;
@end
