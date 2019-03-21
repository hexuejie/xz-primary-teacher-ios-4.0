//
//  StudentHomeworkPictureBooksCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentHomeworkPictureBooksCell : UITableViewCell
- (void)setupScore:(NSNumber *)score withTitle:(NSString *)title withImgName:(NSString *)imageName;
- (void)setupShowScore:(NSNumber *)score withTitle:(NSString *)title withImgName:(NSString *)imageName;
- (void)setupArrowImgV:(BOOL)isShow;
@end
