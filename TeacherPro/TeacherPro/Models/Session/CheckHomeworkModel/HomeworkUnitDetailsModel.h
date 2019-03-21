 
//  HomeworkUnitDetailModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/13.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class HomeworkUnitDetailModel;
@protocol HomeworkUnitDetailModel <NSObject>
 
@end
@interface HomeworkUnitDetailsModel : Model
@property(nonatomic, strong)NSNumber * voiceType;//为true是语音，否是不是
@property(nonatomic, strong) NSArray <HomeworkUnitDetailModel> *questScores;
@end

@interface HomeworkUnitDetailModel : Model
@property(nonatomic, copy)NSString * cn;
@property(nonatomic, copy)NSString * en;
@property(nonatomic, copy)NSString * questionId;
@property(nonatomic, strong)NSNumber * score;
@property(nonatomic, copy) NSString * voice;

@end
