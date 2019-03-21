//
//  BookHomeworkYXLXUnitCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkYXLXUnitCell.h"
#import "PublicDocuments.h"

@interface BookHomeworkYXLXUnitCell()
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgV;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation BookHomeworkYXLXUnitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
    
}
- (void)setupSubview{
    
    self.unitLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.unitLabel.font = fontSize_14;
    self.lineView.backgroundColor = project_line_gray;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupUnitName:(NSString *)unitName withSelectedState:(BOOL )selectedSate{
     self.unitLabel.text = unitName;
    if (selectedSate) {
       self.arrowImgV.highlighted = YES;
       self.bgView.backgroundColor = UIColorFromRGB(0xe6f1ff);
        self.unitLabel.textColor = project_main_blue;
    }else{
       self.arrowImgV.highlighted = NO;
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.unitLabel.textColor = UIColorFromRGB(0x6b6b6b);
     }
}

- (void)setupArrowImgHidden:(BOOL)hidden{
    self.arrowImgV.hidden = hidden;
}
@end
