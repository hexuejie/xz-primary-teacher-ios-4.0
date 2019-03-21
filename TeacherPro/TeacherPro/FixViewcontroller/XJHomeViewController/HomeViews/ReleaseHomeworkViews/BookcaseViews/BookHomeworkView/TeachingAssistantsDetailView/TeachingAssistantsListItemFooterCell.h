//
//  TeachingAssistantsListItemFooterCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WrittenParseBlock)(NSIndexPath * indexPath);
typedef void(^ChooseParseBlock)();

@interface TeachingAssistantsListItemFooterCell : UITableViewCell

@property(nonatomic, strong) NSIndexPath * indexPath;
@property(nonatomic, copy) WrittenParseBlock writttenBlock;
@property(nonatomic, copy) ChooseParseBlock  chooseParseBlock;

@end
