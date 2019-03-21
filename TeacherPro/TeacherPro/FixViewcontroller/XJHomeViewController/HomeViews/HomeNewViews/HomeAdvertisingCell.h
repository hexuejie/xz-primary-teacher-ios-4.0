//
//  HomeAdvertisingCell.h
//  TeacherPro
//
//  Created by DCQ on 2018/5/28.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TouchType) {
    TouchType_Advertising = 0 ,
    TouchType_check      ,//检查
    TouchType_release    ,//发布
    TouchType_huigu    ,//回顾
};
typedef void(^HomeAdvertisingTouchBlock)(TouchType type);
typedef void(^AdvertisingContentBlock)(NSInteger  advertisingIndex);
@class HomeListModel;
@interface HomeAdvertisingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet UIView *advertisingView; 
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;
@property (weak, nonatomic) IBOutlet UIImageView *msgImgV;
@property (copy, nonatomic)  HomeAdvertisingTouchBlock touckBlock;
@property (copy, nonatomic) AdvertisingContentBlock  advertisingBlock;
- (void)setupHomeAdModel:(HomeListModel *)model;
@end
