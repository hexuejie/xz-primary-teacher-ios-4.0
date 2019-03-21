//
//  WrittenParseItemConentImageCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WrittenParseDetailButtonBlock)( CGFloat height);
@class QuestionModel;
@interface WrittenParseItemConentImageCell : UITableViewCell
@property(nonatomic, copy) WrittenParseDetailButtonBlock  detailBlock; 
@property(nonatomic, assign) CGFloat defaultHeight;
- (void)setupModel:(QuestionModel *)model withImgHeight:(CGFloat) height;
- (void)setupButtonState:(BOOL)state;
@end
