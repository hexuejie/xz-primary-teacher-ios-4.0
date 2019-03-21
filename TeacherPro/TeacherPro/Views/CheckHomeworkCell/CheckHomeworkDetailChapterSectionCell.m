//
//  CheckHomeworkChapterSectionCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/31.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "CheckHomeworkDetailChapterSectionCell.h"
#import "PublicDocuments.h"
//章节 标题

@interface CheckHomeworkDetailChapterSectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *chapterTitleLabel;
@end
@implementation CheckHomeworkDetailChapterSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{
    
    self.imgV.backgroundColor = UIColorFromRGB(0x33AAFF);
//    self.chapterTitleLabel.textColor = UIColorFromRGB(0x868d98);
//    self.chapterTitleLabel.font = fontSize_14;
    self.imgV.layer.cornerRadius = 10/2;
    self.imgV.layer.masksToBounds = YES;
}

- (void)setupUnitTitle:(NSString *)title{

    self.chapterTitleLabel.text = title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
