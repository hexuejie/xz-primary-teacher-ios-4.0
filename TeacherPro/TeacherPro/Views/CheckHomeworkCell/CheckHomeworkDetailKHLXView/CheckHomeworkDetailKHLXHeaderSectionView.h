//
//  CheckHomeworkDetailKHLXHeaderSectionView.h
//  TeacherPro
//
//  Created by DCQ on 2018/2/1.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CheckHomeworkDetailKHLXHeaderSectionBlock)(NSInteger section);
@interface CheckHomeworkDetailKHLXHeaderSectionView : UITableViewHeaderFooterView
@property(nonatomic, assign) NSInteger section;
@property(nonatomic, copy) CheckHomeworkDetailKHLXHeaderSectionBlock   btnBlock;
- (void)setupUnitName:(NSString *)unitName withTopicNumber:(NSInteger)number withExpectTime:(NSNumber *)expectTime;
- (void)setupCompleteNumber:(NSNumber *)number;
@end
