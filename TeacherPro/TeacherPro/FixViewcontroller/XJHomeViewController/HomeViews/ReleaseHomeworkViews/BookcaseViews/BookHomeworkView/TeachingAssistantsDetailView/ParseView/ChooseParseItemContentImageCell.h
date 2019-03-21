//
//  ChooseParseItemContentImageCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ChooseParseDetailButtonBlock)( CGFloat height);
@class QuestionModel;
@interface ChooseParseItemContentImageCell : UITableViewCell
@property(nonatomic, copy) ChooseParseDetailButtonBlock  detailBlock;
@property(nonatomic, assign) CGFloat defaultHeight;
- (void)setupModel:(QuestionModel *)model withImgHeight:(CGFloat) height withIndexPath:(NSInteger )index;
- (void)setupButtonState:(BOOL)state;
@end
