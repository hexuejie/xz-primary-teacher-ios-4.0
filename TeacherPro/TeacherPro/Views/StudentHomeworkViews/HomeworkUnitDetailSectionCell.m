//
//  HomeworkUnitDetailSectionCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/12.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "HomeworkUnitDetailSectionCell.h"
#import "PublicDocuments.h"
@interface HomeworkUnitDetailSectionCell()

@property (weak, nonatomic) IBOutlet UILabel *unitTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *unitTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end
@implementation HomeworkUnitDetailSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

    self.unitTypeLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.unitTitleLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.numberLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.unitTitleLabel.font = fontSize_14;
    self.unitTypeLabel.font = fontSize_14;
    self.numberLabel.font = fontSize_14;
    self.bottomLineView.backgroundColor = project_background_gray;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupUnitName:(NSString *)unitName withQuestionNumber:(NSInteger)number withType:(NSString *)type{
    
    self.unitTitleLabel.text = unitName ;
    self.unitTypeLabel.text = type;
    self.numberLabel.text = [NSString stringWithFormat:@"共%zd题",number];
}

// If you are not using auto layout, override this method, enable it by setting
// "fd_enforceFrameLayout" to YES.
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    
    totalHeight += [self.unitTitleLabel sizeThatFits:size].height;
     
    totalHeight += FITSCALE(20); // margins
    totalHeight += FITSCALE(20); // margins
    return CGSizeMake(size.width, totalHeight);
}

@end
