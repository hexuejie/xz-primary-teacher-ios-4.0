//
//  RepostioryAssistantsViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseCollectionViewController.h"
@class SubjectsModel;
@class GradesModel;
 
@interface RepostioryAssistantsViewController : BaseCollectionViewController
@property(nonatomic, strong) SubjectsModel *subjectsModel;
@property(nonatomic, strong) GradesModel  *gradesModel;

@end
