//
//  HomeworkProblemsDetailUnitSwitchView.m
//  TeacherPro
//
//  Created by DCQ on 2018/3/1.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HomeworkProblemsDetailUnitSwitchView.h"
#import "PublicDocuments.h"
@interface HomeworkProblemsDetailUnitSwitchView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@end
@implementation HomeworkProblemsDetailUnitSwitchView
 
- (void)awakeFromNib{
    
    [super awakeFromNib];
    [self setupSubview];
}

- (void)setupSubview{
 
    self.titleLabel.textColor = project_main_blue;
    self.titleLabel.font = fontSize_13;
    self.lineV.backgroundColor = project_line_gray;
 
}
@end
