//
//  BookHomeworkChildrenUnitCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkChildrenUnitCell.h"
#import "PublicDocuments.h"

@interface BookHomeworkChildrenUnitCell()
@property (weak, nonatomic) IBOutlet UILabel *childrenUnitLabel;
@property (weak, nonatomic) IBOutlet UIView *lineV;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgV;

@end

 
@implementation BookHomeworkChildrenUnitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

    self.lineV.backgroundColor = project_line_gray;
    self.childrenUnitLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.childrenUnitLabel.font = fontSize_14;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupChildrenUnitName:(NSString *)name withSelectedState:(BOOL )selectedSate{
    if (selectedSate) {
        self.arrowImgV.highlighted = YES;
         self.childrenUnitLabel.textColor = project_main_blue;
        self.bgView.backgroundColor = UIColorFromRGB(0xe6f1ff);
    }else{
        self.arrowImgV.highlighted = NO;
        self.childrenUnitLabel.textColor = UIColorFromRGB(0x6b6b6b);
        self.bgView.backgroundColor = [UIColor clearColor];
    }
    self.childrenUnitLabel.text = name;
}

- (void)setupArrowImgHidden:(BOOL)hidden{
    self.arrowImgV.hidden = hidden;
}
@end
