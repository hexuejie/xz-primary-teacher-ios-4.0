//
//  ReleaseBookworkCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/13.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReleaseBookworkDeleteBlock)(NSIndexPath *index);
@interface ReleaseBookworkCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property(nonatomic, strong) NSIndexPath * index;
@property(nonatomic, copy) ReleaseBookworkDeleteBlock deleteBlock;
- (void)setupBookworkInfo:(NSString *)info;
- (void)setuphomeworkBookInfo:(NSDictionary *)dic;
- (void)showHemoworkDetailType;
@end
