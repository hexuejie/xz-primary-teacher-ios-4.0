//
//  ChooseParseMyEditCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/29.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ChooseParseMyEditBlock)();
typedef void(^ChooseParseMyDeleteBlock)();
@interface ChooseParseMyEditCell : UITableViewCell
@property(nonatomic, copy) ChooseParseMyEditBlock editBlock;
@property(nonatomic, copy) ChooseParseMyDeleteBlock deleteBlock;
@end
