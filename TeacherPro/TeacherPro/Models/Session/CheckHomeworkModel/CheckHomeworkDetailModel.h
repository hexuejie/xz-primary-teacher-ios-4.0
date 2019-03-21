 
//  CheckHomeworkDetailModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class BookHomeworkModel;
@protocol BookHomeworkModel <NSObject>

@end
@interface CheckHomeworkDetailModel : Model
@property(nonatomic,copy) NSString * text;//文字
@property(nonatomic,copy) NSString *endTime;//结束时间
@property(nonatomic,copy) NSString *feedback;//反馈方式
@property(nonatomic,copy) NSArray *photos;//图像地址
@property(nonatomic,copy) NSString *sound;//音频地址
@property(nonatomic, strong) NSArray *bookHomeworks;
@end

@interface BookHomeworkModel : Model
@property(nonatomic, copy)  NSString *bookName;//书名
@property(nonatomic, copy)  NSString *coverImage;//图片地址

@end
