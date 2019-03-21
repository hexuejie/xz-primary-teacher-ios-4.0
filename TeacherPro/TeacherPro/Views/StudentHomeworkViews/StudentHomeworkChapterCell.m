//
//  StudentHomeworkChapterCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/31.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "StudentHomeworkChapterCell.h"
#import "PublicDocuments.h"
@interface StudentHomeworkChapterCell()
@property (weak, nonatomic) IBOutlet UILabel *chapterTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@end
@implementation StudentHomeworkChapterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

//    self.imgV.backgroundColor = UIColorFromRGB(0xff2e2e);
    self.chapterTitleLabel.textColor = project_main_blue;
    self.chapterTitleLabel.font = fontSize_14;
//    self.imgV.layer.cornerRadius = 10/2;
//    self.imgV.layer.masksToBounds = YES;
}

- (void)setupChapterTitle:(NSString *)title{

    self.chapterTitleLabel.text = title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
