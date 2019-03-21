//
//  WrittenParseItemUploadImageCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WrittenParseAddImageBlock)();
typedef void(^WrittenParseDeleteImageBlock)();
@interface WrittenParseItemUploadImageCell : UITableViewCell
- (void)setupImage:(UIImage *)image;
- (void)setupImageUrl:(NSString *)imageUrl;
@property(nonatomic, copy) WrittenParseAddImageBlock addImageBlock;
@property(nonatomic, copy) WrittenParseDeleteImageBlock deleteImageBlock;
@end
