//
//  WriteViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/25.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ReleaseHomeworkViewController.h"

typedef void(^WriteMessageSucceedBlock)();
@interface WriteMessageViewController : ReleaseHomeworkViewController
@property(nonatomic, copy) WriteMessageSucceedBlock  sucessSendBlock;
@end
