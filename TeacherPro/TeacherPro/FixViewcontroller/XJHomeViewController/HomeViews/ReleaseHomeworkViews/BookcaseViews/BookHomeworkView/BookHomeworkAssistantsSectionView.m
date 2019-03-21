//
//  BookHomeworkAssistantsSectionView.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkAssistantsSectionView.h"
#import "PublicDocuments.h"


@interface BookHomeworkAssistantsSectionView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation BookHomeworkAssistantsSectionView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupView];
}

- (void)setupView{
    
    self.titleLabel.font = fontSize_14;
    self.titleLabel.textColor = project_main_blue;
}
@end
