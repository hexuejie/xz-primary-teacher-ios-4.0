//
//  RespositoryHeaderTagView.h
//  TeacherPro
//
//  Created by 何学杰 on 2018/11/28.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RespositoryQueryModel.h"

NS_ASSUME_NONNULL_BEGIN

@class RespositoryHeaderTagView;

@protocol RespositoryHeaderTagViewDelegate <NSObject>

- (void)eespositoryHeaderClick:(RespositoryHeaderTagView *)tagView;
@end

@interface RespositoryHeaderTagView : UIView

@property (nonatomic,strong) UILabel *tagLabel;
@property (nonatomic,strong) UIButton *queryButton;
@property(nonatomic, weak) id<RespositoryHeaderTagViewDelegate> delegate;



@end

NS_ASSUME_NONNULL_END
