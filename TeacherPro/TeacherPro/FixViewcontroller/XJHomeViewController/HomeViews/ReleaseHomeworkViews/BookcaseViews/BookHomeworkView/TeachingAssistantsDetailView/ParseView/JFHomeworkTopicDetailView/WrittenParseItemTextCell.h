//
//  WrittenParseItemTextCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WrittenParseInputTextBlock)(NSString * inputText);
@interface WrittenParseItemTextCell : UITableViewCell
@property(nonatomic, copy) WrittenParseInputTextBlock inputTextBlock;
- (void)setupText:(NSString *)text;
@end
