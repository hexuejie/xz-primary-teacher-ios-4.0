
//
//  StudentNoFeedbackCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "StudentNoFeedbackCell.h"
#import "PublicDocuments.h"
@interface StudentNoFeedbackCell()
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property(weak, nonatomic)IBOutlet UILabel * title;
@end
@implementation StudentNoFeedbackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.title.textColor = UIColorFromRGB(0x6b6b6b);
    self.title.font = fontSize_14;
    self.bottomLine.backgroundColor = project_line_gray;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
