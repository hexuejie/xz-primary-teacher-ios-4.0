//
//  HomeworkConfirmationItemCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomeworkConfirmationPreviewBlock)( NSIndexPath * index);
@interface HomeworkConfirmationItemCell : UITableViewCell
@property (nonatomic,strong) NSIndexPath * index;
@property (nonatomic,strong) HomeworkConfirmationPreviewBlock previewBlock;
- (void)setupTitle:(NSString *)title withDetail:(NSString *)detail withIcon:(NSString *)imageName;
@end
