//
//  BaseHomeworkUnitViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"
typedef NS_ENUM(NSInteger, BookHomeworkTypeUnitType){
    
    BookHomeworkTypeUnitType_YXLX       = 0,//游戏练习
    BookHomeworkTypeUnitType_TKWLY         ,//听课文录音
    BookHomeworkTypeUnitType_LDKW          ,//朗读课文
    BookHomeworkTypeUnitType_DCTX           ,//单词听写
    BookHomeworkTypeUnitType_YWDD           ,//语文点读
};
@class BookPreviewDetailModel;
@class PracticeTypeModel;
@interface BaseHomeworkUnitViewController : BaseTableViewController
@property(nonatomic, strong) BookPreviewDetailModel * model;
@property(nonatomic, strong) PracticeTypeModel * typeModel;
@property(nonatomic, assign) BookHomeworkTypeUnitType unitType;
@property(nonatomic ,strong) NSIndexPath * selectedIndex;
@property(nonatomic, assign) NSInteger  passCount;//默认1遍
 
@property(nonatomic, strong) NSArray * oldCacheData;
- (instancetype)initWithBookDetail:(BookPreviewDetailModel *)model withTitle:(PracticeTypeModel *)typeModel withCacheData:(NSArray *)cacheData;
@end
