//
//  BookPreviewDetailTitleCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookPreviewDetailModel;

@interface BookPreviewDetailTitleCell : UICollectionViewCell

- (void)setupPreviewDetailInfo:(BookPreviewDetailModel *)detailModel ;

@property (weak, nonatomic) IBOutlet UIImageView *intoImageView;

@end
