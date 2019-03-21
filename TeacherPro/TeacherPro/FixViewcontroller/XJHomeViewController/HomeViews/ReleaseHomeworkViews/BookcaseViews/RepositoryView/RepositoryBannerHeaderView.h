//
//  RepostioryBannerHeaderView.h
//  TeacherPro
//
//  Created by DCQ on 2018/2/27.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RepositoryBannerHeaderViewBottomType){
    
    RepositoryBannerHeaderViewBottomType_book         = 0,
    RepositoryBannerHeaderViewBottomType_cartoon         ,
    RepositoryBannerHeaderViewBottomType_assistants     ,
};
typedef void(^RepositoryBannerHeaderViewBottomBlock)(RepositoryBannerHeaderViewBottomType type);
@class SDCycleScrollView;
@interface RepositoryBannerHeaderView : UIView
@property(nonatomic, copy) RepositoryBannerHeaderViewBottomBlock  bottomBlock;
- (void)setupBanner;
@end

