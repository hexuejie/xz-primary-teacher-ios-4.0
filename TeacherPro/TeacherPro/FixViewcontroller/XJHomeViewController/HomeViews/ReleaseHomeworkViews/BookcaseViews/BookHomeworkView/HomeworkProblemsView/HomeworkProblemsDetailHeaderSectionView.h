//
//  HomewrokProblemsDetailHeaderSectionView.h
//  TeacherPro
//
//  Created by DCQ on 2018/1/22.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^HomeworkProblemsDetailSectionBlock)(BOOL btnSelected, NSInteger section);
@class HomeworkProblemsDetailModel;
@interface HomeworkProblemsDetailHeaderSectionView : UITableViewHeaderFooterView
@property(nonatomic, copy) HomeworkProblemsDetailSectionBlock   btnBlock;
@property(nonatomic, assign) NSInteger section;
- (void)setupUnitModel:(HomeworkProblemsDetailModel *) model;
- (void)setupUnitDic:(NSDictionary *) item;
- (void)setupSelectedTotailBtnState:(BOOL)state;
@end
