//
//  GradeNewListViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

typedef void(^GradeListSelectedGradeBlock)(NSDictionary * selectedDic);

@interface GradeNewListViewController : BaseTableViewController
@property(nonatomic, copy) GradeListSelectedGradeBlock  selectedGradeBlock;
@end
