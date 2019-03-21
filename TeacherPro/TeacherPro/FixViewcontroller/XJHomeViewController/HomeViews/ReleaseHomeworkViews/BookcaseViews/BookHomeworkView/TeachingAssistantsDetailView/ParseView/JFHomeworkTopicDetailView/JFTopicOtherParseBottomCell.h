//
//  JFTopicOtherParseBottomCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/22.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JFTopicOtherParsePraiseBlock)(NSIndexPath * indexPath);
typedef void(^JFTopicOtherParseSelectedBlock)(NSIndexPath * indexPath);
@interface JFTopicOtherParseBottomCell : UITableViewCell
@property(nonatomic, strong) NSIndexPath * indexPath;
@property(nonatomic, copy) JFTopicOtherParsePraiseBlock praiseBlock;
@property(nonatomic, copy) JFTopicOtherParseSelectedBlock selectedBlock;

- (void)setupPraiseNumber:(NSNumber *)number withHasPraiseState:(NSNumber *)hasPraise;

@end
