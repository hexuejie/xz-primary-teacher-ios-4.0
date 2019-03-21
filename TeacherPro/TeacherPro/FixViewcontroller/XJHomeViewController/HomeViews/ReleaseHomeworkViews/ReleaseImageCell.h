//
//  ReleaseImageCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/13.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReleaseImageDeleteBlock)(UIButton * btn);
typedef void(^ReleaseImageLookBlock)(NSIndexPath * index);
@interface ReleaseImageCell : UITableViewCell
- (void)setupReleaseImageCellPhotos:(NSMutableArray *)selectedPhotos withAssets:(NSMutableArray *)selectedAssets;
 
@property(nonatomic, copy) ReleaseImageDeleteBlock deleteBlock;
@property(nonatomic, copy) ReleaseImageLookBlock  lookImageBlock;
@end
