//
//  RepositoryBookSectionView.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/18.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,RepositoryBookType){
    
    RepositoryBookType_gard      = 0,//年级
    RepositoryBookType_subjects     ,//科目 
    RepositoryBookType_version      ,//版本
};

typedef void(^RepositoryBookChooseBlock)(RepositoryBookType  type,BOOL isOpen);

@interface RepositoryBookSectionView : UICollectionReusableView
@property(nonatomic, copy) RepositoryBookChooseBlock chooseBlock;
- (void)setupButtonTitle:(NSString *)name withType:(NSInteger )type;
@end
