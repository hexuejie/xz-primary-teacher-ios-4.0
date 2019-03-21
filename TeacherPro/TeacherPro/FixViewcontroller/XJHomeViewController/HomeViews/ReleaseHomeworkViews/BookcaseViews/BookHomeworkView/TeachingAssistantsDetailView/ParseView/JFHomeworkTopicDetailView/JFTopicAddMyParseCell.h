//
//  JFTopicAddMyParseCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JFTopicAddMyParseCellBlock)( );
@interface JFTopicAddMyParseCell : UITableViewCell
@property(nonatomic, copy) JFTopicAddMyParseCellBlock addBlock;
@end
