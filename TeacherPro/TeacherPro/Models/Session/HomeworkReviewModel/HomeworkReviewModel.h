 
//  HomeworkReviewListModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/19.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class HomeworkReviewModel;
@protocol HomeworkReviewModel <NSObject>

@end
@interface HomeworkReviewListModel : Model
@property(nonatomic, strong) NSArray <HomeworkReviewModel> *homeworkDays;
@end
@class HomeworkDetialsModel;
@protocol HomeworkDetialsModel <NSObject>

@end
@interface HomeworkReviewModel : Model
@property(nonatomic, strong)NSNumber * existsNotComment;
@property(nonatomic, copy) NSString * day;
@property(nonatomic, strong) NSArray <HomeworkDetialsModel>* homeworkDetials;
@end

@interface  HomeworkDetialsModel: Model
@property(nonatomic, copy) NSString *  clazzName;
@property(nonatomic, copy) NSString *  gradeName;
@property(nonatomic, strong)NSNumber*  remark;//表示是否检查
@property(nonatomic, copy) NSString *  subjectName;
@end
