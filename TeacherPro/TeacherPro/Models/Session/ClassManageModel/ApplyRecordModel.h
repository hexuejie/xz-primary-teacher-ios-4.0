 
//  ApplyRecordModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class ApplyRecordModel;
@protocol ApplyRecordModel<NSObject>
@end
@interface ApplyRecordsModel : Model
@property(nonatomic, strong) NSArray<ApplyRecordModel> * applyClazzs;
@end
@interface ApplyRecordModel : Model
@property (nonatomic, copy) NSString * applyId;
@property (nonatomic, copy) NSString * teacherName;
@property (nonatomic, copy) NSString * clazzName;//班级
@property (nonatomic, copy) NSString * gradeName;//年级

@property (nonatomic, copy) NSString * clazzLogo;//图片
@property (nonatomic, strong) NSNumber * callStatus;//=true 已催促 =false 未催促
@property (nonatomic, copy) NSString * ctime;//时间
@end

