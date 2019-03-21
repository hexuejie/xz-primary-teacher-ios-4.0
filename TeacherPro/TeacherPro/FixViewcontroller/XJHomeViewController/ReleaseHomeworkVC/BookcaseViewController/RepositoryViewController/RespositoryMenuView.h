//
//  RespositoryMenuView.h
//  TeacherPro
//
//  Created by 何学杰 on 2018/11/28.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RespositoryQueryModel.h"

NS_ASSUME_NONNULL_BEGIN

@class RespositoryMenuView;

@protocol RespositoryMenuViewDelegate <NSObject>

- (void)respositoryMenuViewClose:(RespositoryMenuView *)tagView;

- (void)respositoryMenuViewFinish:(RespositoryMenuView *)tagView;
@end



@interface RespositoryMenuView : UIView

@property(nonatomic, strong) SubjectQueryModel *gradeModel;
@property(nonatomic, strong) SubjectQueryModel *publisherModel;
@property(nonatomic, strong) SubjectQueryModel *levelModel;

//@property(nonatomic, assign) NSInteger gradeId;
//@property(nonatomic, strong) NSString *publisherId;
//@property(nonatomic, strong) NSString *level;

@property(nonatomic, copy) BookQueryModel *bookQueryModel;
@property(nonatomic, copy) CartoonQueryModel *cartoonQueryModel;

@property(nonatomic, weak) id<RespositoryMenuViewDelegate> delegate;
- (void)beginShowMenuView;
- (void)closeMenuView;
@end

NS_ASSUME_NONNULL_END
