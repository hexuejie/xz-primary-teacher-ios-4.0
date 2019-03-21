//
//  MultilayerItem.h
//  TeacherPro
//
//  Created by DCQ on 2018/7/26.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MultilayerItem : NSObject
/** 数据 */
@property (nonatomic, strong) id data;
/** 子层 */
@property (nonatomic, strong) NSArray<MultilayerItem *> *subs;

#pragma mark - < 辅助属性 >

/** 是否选中 */
@property (nonatomic, assign) BOOL isSelected;

/** 是否展开 */
@property (nonatomic, assign) BOOL isUnfold;

/** 是否能展开 */
@property (nonatomic, assign) BOOL isCanUnfold;

/** 当前层级 */
@property (nonatomic, assign) NSInteger index;
@end
