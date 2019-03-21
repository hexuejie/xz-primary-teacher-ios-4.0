//
//  RepositoryBannerCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/12.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RepositoryBannerBottomType){

    RepositoryBannerBottomType_book         = 0,
    RepositoryBannerBottomType_cartoon         ,
    RepositoryBannerBottomType_assistants     ,
};
typedef void(^RepositoryBannerCellBottomBlock)(RepositoryBannerBottomType type);
@class SDCycleScrollView;
@interface RepositoryBannerCell : UICollectionViewCell
@property(nonatomic, copy) RepositoryBannerCellBottomBlock  bottomBlock;
- (void)setupBanner;
@end
