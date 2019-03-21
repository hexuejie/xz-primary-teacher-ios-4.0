//
//  HomeworkConfirmationChapterCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "HomeworkConfirmationChapterCell.h"
#import "PublicDocuments.h"

@interface HomeworkConfirmationChapterCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pointImgV;

@end
@implementation HomeworkConfirmationChapterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

    self.titleLabel.textColor = UIColorFromRGB(0x868d98);
    self.titleLabel.font = fontSize_12;
    self.pointImgV.backgroundColor =  UIColorFromRGB(0xff607a);
    self.pointImgV.layer.masksToBounds = YES;
    self.pointImgV.layer.cornerRadius = 5;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupChapterName:(NSString *)chapterName{

    self.titleLabel.text = chapterName;
}
@end
