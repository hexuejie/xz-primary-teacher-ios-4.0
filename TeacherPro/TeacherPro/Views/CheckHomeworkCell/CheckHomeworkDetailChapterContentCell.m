//
//  CheckHomewrokChapterContentCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/31.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "CheckHomeworkDetailChapterContentCell.h"
#import "PublicDocuments.h"
///内容

@interface CheckHomeworkDetailChapterContentCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView  *bottomLine;

@end
@implementation CheckHomeworkDetailChapterContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.contentLabel.textColor =  UIColorFromRGB(0x9f9f9f);
//    self.contentLabel.font = fontSize_14;
    self.bottomLine.backgroundColor = HexRGB(0xF5F5F5);
    
}
- (void)setupContent:(NSString *)content{
    
    self.contentLabel.text = content;
}

- (void)setupHiddenLine{

    self.bottomLine.hidden = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
