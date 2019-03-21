//
//  BookPreviewDetailTypeCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PracticeTypeModel;

@interface BookPreviewDetailTypeCell : UICollectionViewCell
-(void)setupDetailType:(PracticeTypeModel *)model withImgDic:(NSDictionary *)imgDic;
@end
