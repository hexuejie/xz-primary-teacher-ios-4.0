//
//  kickedOutStudentsViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/4.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "NewClassDetailStudentViewController.h"

typedef void(^KickedOutUpdateStudentListBlock)();
@interface KickedOutStudentsViewController : NewClassDetailStudentViewController
@property(nonatomic, copy) KickedOutUpdateStudentListBlock updateBlock;
@end
