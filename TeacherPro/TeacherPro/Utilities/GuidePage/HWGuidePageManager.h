//
//  HWGuidePageManager.h
//  TransparentGuidePage
//
//  Created by wangqibin on 2018/4/20.
//  Copyright © 2018年 sensmind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef void(^FinishBlock)(void);

typedef NS_ENUM(NSInteger, HWGuidePageType) {
    HWGuidePageType_Review = 0,//作业回顾
    HWGuidePageType_Class,//班级
    HWGuidePageType_Share,//分享
};

@interface HWGuidePageManager : NSObject
 
// 获取单例
+ (instancetype)shareManager;

/**
 显示方法

 @param type 指引页类型
 */
- (void)showGuidePageWithType:(HWGuidePageType)type withGuideFrame:(CGRect)guideAreaFrame;

/**
 显示方法

 @param type 指引页类型
 @param completion 完成时回调
 */
- (void)showGuidePageWithType:(HWGuidePageType)type withGuideFrame:(CGRect)guideAreaFrame completion:(FinishBlock)completion ;

@end
