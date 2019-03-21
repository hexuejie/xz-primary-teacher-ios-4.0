//
//  TeachingAssistantsDetailCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WireframeView :UIView

@property (nonatomic, copy) NSString *unitId;
@property (nonatomic, copy) NSString *questionNum;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, copy) NSString *id;
- (void)setupViewStatus:(BOOL)status;
@end


@class PhotoPreviewView;
@class AssistantsDetailModel;
@interface TeachingAssistantsDetailCell : UICollectionViewCell
@property (nonatomic, copy) void (^singleTapGestureBlock)(NSString * unitId, NSString *questionNum,NSIndexPath * indexPath);
@property (nonatomic, copy) void (^singleYWDDTapGestureBlock)(NSString * unitId, NSString *readId,NSIndexPath * indexPath);
@property (nonatomic, copy) void (^imageProgressUpdateBlock)(double progress);
@property (nonatomic, strong) PhotoPreviewView *previewView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL allowCrop;
@property (nonatomic, assign) CGRect cropRect;
@property (nonatomic, assign) NSInteger currentPage;
 
- (void)setupModel:(AssistantsDetailModel *)model withSelectedData:(NSArray *)selectedArray;
- (void)setupChangeSeleted:(BOOL)changeSeleted;
- (void)recoverSubviews;
@end


@interface PhotoPreviewView : UIView
 
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, assign) NSInteger currentPage;
- (void)setupModel:(AssistantsDetailModel *)model atIndexPath:(NSIndexPath *)indexPath withSelectedData:(NSArray *)selectedArray;
@property (nonatomic, assign) BOOL allowCrop;
@property (nonatomic, assign) BOOL isChangeSeleted;
@property (nonatomic, assign) CGRect cropRect;
 @property (nonatomic, copy) void (^singleYWDDTapGestureBlock)(NSString * unitId, NSString *readId);
@property (nonatomic, copy) void (^singleTapGestureBlock)(NSString * unitId, NSString *questionNum);
@property (nonatomic, copy) void (^imageProgressUpdateBlock)(double progress);

- (void)recoverSubviews;
@end


