//
//  InformationDetailViewController.h
//  TeacherPro
//
//  Created by DCQ on 2018/6/21.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNetworkViewController.h"
@class HomeNewsModel;
typedef NS_ENUM(NSInteger,InformationDetailType){
    InformationDetailType_normal = 0,
    InformationDetailType_newsDetail  , //新闻
    InformationDetailType_advDetail ,//广告
};

typedef void(^NewsDetailBlock)(NSIndexPath * IndexPath, NSNumber * readCount);
@interface InformationDetailViewController : BaseNetworkViewController
@property(nonatomic, strong) NSIndexPath * indexPath;
- (instancetype)initWithModel:(HomeNewsModel *)newsModel;
- (instancetype)initWithUrl:(NSString *)url withStyle:(InformationDetailType )style;
@property(nonatomic, copy) NewsDetailBlock newsBlock;
@end
