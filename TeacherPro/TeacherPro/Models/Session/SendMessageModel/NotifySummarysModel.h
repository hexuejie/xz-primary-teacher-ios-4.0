 
//  NotifySummaryModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/29.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class NotifySummaryModel;
@protocol NotifySummaryModel;
@interface NotifySummarysModel : Model
@property(nonatomic, strong) NotifySummaryModel* receive;
@end

@interface NotifySummaryModel : Model

@property(nonatomic, strong) NSDictionary * info;
@end
