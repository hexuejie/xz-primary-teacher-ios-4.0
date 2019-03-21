
//
//  BookSearchHotTitleCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookSearchHotTitleCell.h"
#import "PublicDocuments.h"

@interface BookSearchHotTitleCell()
@property (weak, nonatomic) IBOutlet UILabel *hotLabel;

@end
@implementation BookSearchHotTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.hotLabel.textColor = UIColorFromRGB(0x6b6b6b);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
