//
//  JFTopicParseNewAddSectionCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/21.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddParseSwitchBlock)(BOOL state);
@interface JFTopicParseNewAddSectionCell : UITableViewCell
@property(nonatomic, copy) AddParseSwitchBlock switchBlock;
- (void)setupIconImageName:(NSString *)imgName withTitle:(NSString *)title;
- (void)setupSwitch:(BOOL)show;
@end

