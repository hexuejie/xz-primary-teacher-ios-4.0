//
//  RepositoryAssistantsSectionView.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,RepositoryAssistantsType){
    
    RepositoryAssistantsType_gard      = 0,//年级
    RepositoryAssistantsType_subjects     ,//科目
 
};

typedef void(^RepositoryAssistantsChooseBlock)(RepositoryAssistantsType  type,BOOL isOpen);

@interface RepositoryAssistantsSectionView : UICollectionReusableView
@property(nonatomic, copy) RepositoryAssistantsChooseBlock chooseBlock;
- (void)setupButtonTitle:(NSString *)name withType:(NSInteger )type;
@end

