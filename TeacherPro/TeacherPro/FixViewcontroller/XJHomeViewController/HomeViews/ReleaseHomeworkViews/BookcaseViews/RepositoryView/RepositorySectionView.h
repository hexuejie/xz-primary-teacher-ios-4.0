//
//  RepositorySectionView.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,RepostoryChooseType){

    RepostoryChooseType_gard      = 0,//年级
    RepostoryChooseType_subjects     ,//科目
    RepostoryChooseType_type         ,//类型
    RepostoryChooseType_version      ,//版本
};

typedef void(^RepostoryChooseBlock)(RepostoryChooseType  type,BOOL isOpen);
@interface RepositorySectionView : UICollectionReusableView
@property(nonatomic, copy) RepostoryChooseBlock chooseBlock;
- (void)setupButtonTitle:(NSString *)name withType:(NSInteger )type;
@end
