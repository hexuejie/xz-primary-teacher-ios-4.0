//
//  ClassManageSectionCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/31.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassManageModel;
@interface ClassManageSectionCell : UITableViewCell

- (void)setupCellInfo:(ClassManageModel *) info withEditState:(BOOL) edit;
@end
