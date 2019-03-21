//
//  ClassChooseHeaderVIew.h
//  TeacherPro
//
//  Created by 何学杰 on 2018/11/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class ClassChooseHeaderVIew;

@protocol ClassChooseHeaderVIewDelegate <NSObject>

- (void)didChooseHeader:(ClassChooseHeaderVIew *)header;

@end

@interface ClassChooseHeaderVIew : UITableViewHeaderFooterView

@property(nonatomic, assign) id<ClassChooseHeaderVIewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UIButton *allClassButton;


@end

NS_ASSUME_NONNULL_END
